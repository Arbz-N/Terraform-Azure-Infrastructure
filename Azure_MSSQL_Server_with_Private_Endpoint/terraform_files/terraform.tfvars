service_principal = {
  client_id       = "<CLIENT_ID>"
  client_secret   = "<CLIENT_SECRET>"
  tenant_id       = "<TENANT_ID>"
  subscription_id = "<SUBSCRIPTION_ID>"
}

rg_details = {
  name     = "practice"
  location = "australiaeast"
}

vnet_details = {
  name          = "vnet"
  address_space = "10.0.0.0/16"
}

subnet_details = {
  "vm-subnet" = {
    name             = "vm-subnet"
    address_prefixes = "10.0.1.0/24"
  }
  "pe-subnet" = {
    name             = "pe-subnet"
    address_prefixes = "10.0.2.0/24"
  }
}

ip_details = {
  name              = "sql-demo-vm-pip"
  allocation_method = "Static"
}

vm_nsg_name = "sql-demo-vm-nsg"
vm_nic_name = "sql-demo-vm-nic"

vm_details = {
  name    = "sql-demo-ubuntu-vm"
  vm_size = "Standard_D2s_v3"

  os_profile = {
    computer_name  = "hostname"
    admin_username = "<VM_USERNAME>"
    admin_password = "<VM_PASSWORD>"
  }

  storage_os_disk = {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
    disk_size_gb      = 80
  }

  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

mysql_details = {
  name                         = "my-sql-server-xxxxx"
  version                      = "12.0"
  administrator_login          = "<SQL_USERNAME>"
  administrator_login_password = "<SQL_PASSWORD>"
}

database_name = "sample-db"

endpoint_name = {
  name            = "sql-private-endpoint"
  connection_name = "sql-psc"
}

dns_zone_name = "privatelink.database.windows.net"
link_name     = "sql-dns-vnet-link"
a_zone_name   = "my-sql-server-xxxxx"