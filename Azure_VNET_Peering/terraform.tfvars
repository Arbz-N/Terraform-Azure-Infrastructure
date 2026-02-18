service_principal = {
  client_id       = "<CLIENT_ID>"
  client_secret   = "<CLIENT_SECRET>"
  tenant_id       = "<TENANT_ID>"
  subscription_id = "<SUBSCRIPTION_ID>"
}
vnets = {
  vnet1 = {
    name = "vnet-1"
    address_space = "10.0.0.0/16"
  }
  vnet2 = {
    name = "vnet-2"
    address_space = "10.1.0.0/16"
  }
}

vms = {

  vm1 = {
    name    = "vm1"
    vm_size = "Standard_D2s_v3"

    image = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }

    storage = {
      name              = "osdisk-vm1"
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Standard_LRS"
    }

    os_profile = {
      computer_name  = "vm1-host"
      admin_username = "azureuser"
      admin_password = "Password1234!"
    }

    environment = "dev"
    nic_id      = azurerm_network_interface.nic_vm1.id
  }

  vm2 = {
    name    = "vm2"
    vm_size = "Standard_D2s_v3"

    image = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }

    storage = {
      name              = "osdisk-vm2"
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Standard_LRS"
    }

    os_profile = {
      computer_name  = "vm2-host"
      admin_username = "azureuser"
      admin_password = "Password1234!"
    }

    environment = "staging"
    nic_id      = azurerm_network_interface.nic_vm2.id
  }
}
vnets_subnet = {
  vnet1_subnet = {
    name = subnet
    address_prefixes = "10.0.1.0/24"
  }
    vnet2_subnet = {
    name = subnet
    address_prefixes = "10.0.1.0/24"
  }
}

bastion_subnet = {
  for_vnet1 = {
    name = "AzureBastionSubnet"
    address_prefixes = "10.0.2.0/27"
  }
  for_vnet2 = {
    name = "AzureBastionSubnet"
    address_prefixes = "10.1.2.0/27"
  }
}

resource_group = {
  name     = "practice-rg"
  location = "Australia East"
}

peering = {
  vnet1_to_vnet2 = {
    source = "vnet1"
    target = "vnet2"
  }
  vnet2_to_vnet1 = {

    source = "vnet2"
    target = "vnet1"
  }
}
