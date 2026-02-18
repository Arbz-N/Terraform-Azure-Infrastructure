variable "service_principal" {
  description = "Azure Service Principal credentials"
  type        = object({
    client_id       = string
    client_secret   = string
    tenant_id       = string
    subscription_id = string
  })
}

variable "vnet-1_details" {
  type = object({
    name = string
    address_space = string
  })
}
variable "vnet-2_details" {
  type = object({
    name = string
    address_space = string
  })
}