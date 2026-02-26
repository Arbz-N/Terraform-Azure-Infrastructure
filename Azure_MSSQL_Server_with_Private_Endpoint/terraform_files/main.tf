resource "azurerm_resource_group" "rg" {
  location = var.rg_details.location
  name     = var.rg_details.name
}

resource "azurerm_virtual_network" "vnet" {
  location            = var.rg_details.location
  name                = var.vnet_details.name
  resource_group_name = var.rg_details.name
  address_space       = [var.vnet_details.address_space]
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnet_details

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.address_prefixes]
}

resource "azurerm_public_ip" "vm_pip" {
  allocation_method   = var.ip_details.allocation_method
  location            = var.rg_details.location
  name                = var.ip_details.name
  resource_group_name = var.rg_details.name
}

resource "azurerm_network_security_group" "vm_nsg" {
  location            = azurerm_resource_group.rg.location
  name                = var.vm_nsg_name
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "vm_nic" {
  name                = var.vm_nic_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets["vm-subnet"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "vm_nic_nsg" {
  network_interface_id      = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key_pem" {
  filename        = "${path.root}/vm-private-key.pem"
  content         = tls_private_key.ssh_key.private_key_openssh
  file_permission = "0600"
}

resource "azurerm_virtual_machine" "vm" {
  location              = azurerm_resource_group.rg.location
  name                  = var.vm_details.name
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  vm_size               = var.vm_details.vm_size

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = var.vm_details.source_image_reference.publisher
    offer     = var.vm_details.source_image_reference.offer
    sku       = var.vm_details.source_image_reference.sku
    version   = var.vm_details.source_image_reference.version
  }

  storage_os_disk {
    name              = var.vm_details.storage_os_disk.name
    caching           = var.vm_details.storage_os_disk.caching
    managed_disk_type = var.vm_details.storage_os_disk.managed_disk_type
    create_option     = var.vm_details.storage_os_disk.create_option
    disk_size_gb      = var.vm_details.storage_os_disk.disk_size_gb
  }

  os_profile {
    computer_name  = var.vm_details.os_profile.computer_name
    admin_username = "<VM_ADMIN_USERNAME>"
    admin_password = "<VM_ADMIN_PASSWORD>"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_mssql_server" "sql_server" {
  location                         = azurerm_resource_group.rg.location
  name                             = var.mssql_details.name
  resource_group_name              = azurerm_resource_group.rg.name
  version                          = var.mssql_details.version
  administrator_login              = "<SQL_ADMIN_USERNAME>"
  administrator_login_password     = "<SQL_ADMIN_PASSWORD>"
}

resource "azurerm_mssql_database" "example_db" {
  name      = var.database_name
  server_id = azurerm_mssql_server.sql_server.id
  sku_name  = "Basic"
}

resource "azurerm_private_endpoint" "sql_pe" {
  location            = azurerm_resource_group.rg.location
  name                = var.endpoint_name.name
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnets["pe-subnet"].id

  private_service_connection {
    name                           = var.endpoint_name.connection_name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.sql_server.id
    subresource_names              = ["sqlServer"]
  }
}

resource "azurerm_private_dns_zone" "sql_dns" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql_dns_link" {
  name                  = var.link_name
  private_dns_zone_name = azurerm_private_dns_zone.sql_dns.name
  resource_group_name   = azurerm_resource_group.rg.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_a_record" "sql_dns_record" {
  name                = var.a_zone_name
  zone_name           = azurerm_private_dns_zone.sql_dns.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.sql_pe.private_service_connection[0].private_ip_address]
}