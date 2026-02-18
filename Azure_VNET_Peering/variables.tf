variable "service_principal" {
  description = "Azure Service Principal credentials"
  type        = object({
    client_id       = string
    client_secret   = string
    tenant_id       = string
    subscription_id = string
  })
}

variable "vnets" {
  description = "All VNETS Configurations"
  type = object({
    name = string
    address_space = string
  })
}

variable "vms" {
  description = "All VM configurations"
  type = map(object({
    name    = string
    vm_size = string

    image = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })

    storage = object({
      name              = string
      caching           = string
      create_option     = string
      managed_disk_type = string
    })

    os_profile = object({
      computer_name  = string
      admin_username = string
      admin_password = string
    })

    environment = string
    nic_id      = string
  }))
}

variable "vnets_subnet" {
  type = object({
    name = string
    address_prefixes = string
  })
}
variable "bastion_subnet" {
  type = object({
    name = string
    address_prefixes = string
  })
}
variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
}