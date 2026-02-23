variable "keyvault_details" {
  type = object({
    keyvault_name              = string
    location                   = string
    resource_group_name        = string
    service_principal_name     = string
    service_principal_object_id = string
    service_principal_tenant_id = string
  })
}