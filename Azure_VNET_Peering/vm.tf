resource "azurerm_network_interface" "vm1_nic" {
  name                = "vm1-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig-vm1"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm1" {
  name                  = "vm1"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.vm1_nic.id]
  vm_size               = "Standard_D2s_v3"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk-vm1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "vm1-hostname"
    admin_username = "<ADMIN_USERNAME>"
    admin_password = "<STRONG_PASSWORD>"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "<ENVIRONMENT>"
  }
}


resource "azurerm_network_interface" "vm2_nic" {
  name                = "vm2-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig-vm2"
    subnet_id                     = azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm2" {
  name                  = "vm2"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.vm2_nic.id]
  vm_size               = "Standard_D2s_v3"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk-vm2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "vm2-hostname"
    admin_username = "<ADMIN_USERNAME>"
    admin_password = "<STRONG_PASSWORD>"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "<ENVIRONMENT>"
  }
}


resource "azurerm_public_ip" "bastion_ip" {
  allocation_method   = "Static"
  location            = azurerm_resource_group.rg.location
  name                = "bastion-public-ip"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_bastion_host" "bastion" {
  location            = azurerm_resource_group.rg.location
  name                = "bastion-host"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "AzureBastionSubnet"
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
    subnet_id            = azurerm_subnet.subnet1.id
  }
}
