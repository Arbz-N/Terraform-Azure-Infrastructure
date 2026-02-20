service_principal = {
  client_id       = "<CLIENT_ID>"
  client_secret   = "<CLIENT_SECRET>"
  tenant_id       = "<TENANT_ID>"
  subscription_id = "<SUBSCRIPTION_ID>"
}

vnets = {
  vnet1 = {
    name          = "vnet-1"
    address_space = "10.0.0.0/16"
  }
  vnet2 = {
    name          = "vnet-2"
    address_space = "10.1.0.0/16"
  }
}

resource_group = {
  rg1 = {
    name     = "practice-rg"
    location = "Australia East"
  }
}

vnets_subnet = {
  vnet1_subnet = {
    name             = "subnet-vnet1"
    address_prefixes = "10.0.1.0/24"
    vnet_name        = "vnet1"
  }
  vnet2_subnet = {
    name             = "subnet-vnet2"
    address_prefixes = "10.1.1.0/24"
    vnet_name        = "vnet2"
  }
}

bastion_subnet = {
  for_vnet1 = {
    name             = "AzureBastionSubnet"
    address_prefixes = "10.0.2.0/27"
    vnet_name        = "vnet1"
  }
  for_vnet2 = {
    name             = "AzureBastionSubnet"
    address_prefixes = "10.1.2.0/27"
    vnet_name        = "vnet2"
  }
}

nics = {
  for_vm1 = {
    ip_name                       = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    subnet_key                    = "vnet1_subnet"
  }
  for_vm2 = {
    ip_name                       = "ipconfig2"
    private_ip_address_allocation = "Dynamic"
    subnet_key                    = "vnet2_subnet"
  }
}

vms = {
  vm1 = {
    name    = "vm1"
    vm_size = "Standard_D2s_v3"
    nic_key = "for_vm1"

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
  }

  vm2 = {
    name    = "vm2"
    vm_size = "Standard_D2s_v3"
    nic_key = "for_vm2"

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
  }
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

ips_for_bastion = {
  for_vm1 = {
    name              = "bastion-ip-vm1"
    allocation_method = "Static"
    sku               = "Standard"
  }
  for_vm2 = {
    name              = "bastion-ip-vm2"
    allocation_method = "Static"
    sku               = "Standard"
  }
}

bastion_vms = {
  b_vm1 = {
    vm_name        = "bastion-vm-1"
    ip_name        = "bastion-ipconfig"
    subnet_key     = "for_vnet1"
    ip_address_key = "for_vm1"
  }
  b_vm2 = {
    vm_name        = "bastion-vm-2"
    ip_name        = "bastion-ipconfig"
    subnet_key     = "for_vnet2"
    ip_address_key = "for_vm2"
  }
}
