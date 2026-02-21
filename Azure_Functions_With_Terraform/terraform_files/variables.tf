variable "service_principal" {
  description = "Azure Service Principal credentials"
  type        = object({
    client_id       = string
    client_secret   = string
    tenant_id       = string
    subscription_id = string
  })
}

variable "random_length" {
  type = number
  default = 4
}

variable "rg_details" {
  type = object({
    name     = string
    location = string
  })
}

variable "storage_account_details" {
  type = object({
    account_replication_type = string
    account_tier             = string
    name                     = string
  })
}
variable "service_plan_details" {
  type = object({
    name  = string
    os_type = string
    sku_name = string
  })
}
variable "func_details" {
  type = object({
    name = string
    node_version = string
  })
}