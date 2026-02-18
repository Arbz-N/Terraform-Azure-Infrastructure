variable "service_principal" {
  description = "Azure Service Principal credentials"
  type = object({
    client_id       = string
    client_secret   = string
    tenant_id       = string
    subscription_id = string
  })
}

variable "vnets" {
  description = "All VNETS Configurations"
  type = map(object({
    name          = string
    address_space = string
  }))
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
    nic_key     = string
  }))
}

variable "vnets_subnet" {
  type = map(object({
    name              = string
    address_prefixes  = string
    vnet_name         = string
  }))
}

variable "bastion_subnet" {
  type = map(object({
    name              = string
    address_prefixes  = string
    vnet_name         = string
  }))
}

variable "resource_group" {
  type = map(object({
    name     = string
    location = string
  }))
}

variable "peering" {
  type = map(object({
    source = string
    target = string
  }))
}

variable "nics" {
  type = map(object({
    ip_name                       = string
    private_ip_address_allocation = string
    subnet_key                    = string
  }))
}

variable "ips_for_bastion" {
  type = map(object({
    name              = string
    allocation_method = string
    sku               = string
  }))
}

variable "bastion_vms" {
  type = map(object({
    vm_name        = string
    ip_name        = string
    subnet_key     = string
    ip_address_key = string
  }))
}
