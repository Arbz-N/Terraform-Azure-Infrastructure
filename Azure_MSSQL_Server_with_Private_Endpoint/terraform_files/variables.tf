variable "service_principal" {
  description = "Azure Service Principal credentials"
  type = object({
    client_id       = string
    client_secret   = string
    tenant_id       = string
    subscription_id = string
  })
}

variable "rg_details" {
  type = object({
    name     = string
    location = string
  })
}


variable "vnet_details" {
  type = object({
    name          = string
    address_space = string
  })
}

variable "subnet_details" {
  type = map(object({
    name             = string
    address_prefixes = string
  }))
}

variable "ip_details" {
  type = object({
    name              = string
    allocation_method = string
  })
}

variable "vm_nsg_name" {
  type = string
}

variable "vm_nic_name" {
  type = string
}

variable "vm_details" {
  type = object({
    name    = string
    vm_size = string

    os_profile = object({
      computer_name  = string
      admin_username = string
      admin_password = string
    })

    storage_os_disk = object({
      name              = string
      caching           = string
      managed_disk_type = string
      create_option     = string
      disk_size_gb      = number
    })

    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
  })
}

variable "mssql_details" {
  type = object({
    name                         = string
    version                      = string
    administrator_login          = string
    administrator_login_password = string
  })
}

variable "database_name" {
  type = string
}

variable "endpoint_name" {
  type = object({
    name            = string
    connection_name = string
  })
}

variable "dns_zone_name" {
  type = string
}

variable "link_name" {
  type = string
}

variable "a_zone_name" {
  type = string
}