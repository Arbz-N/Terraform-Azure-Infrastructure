variable "service_principal" {
  description = "Azure Service Principal credentials"
  type = object({
    client_id       = string
    client_secret   = string
    tenant_id       = string
    subscription_id = string
  })
}

variable "resource_group_details" {
  description = "Azure resource group configuration"
  type = object({
    name     = string
    location = string
  })
}

variable "storge_account_details" {
  description = "Azure storage account configuration"
  type = object({
    name                     = string
    account_replication_type = string
    account_tier             = string
  })
}
