variable "service_principal" {
  description = "Azure Service Principal credentials"
  type        = object({
    client_id       = string
    client_secret   = string
    tenant_id       = string
    subscription_id = string
  })
}
variable "prefix" {
  type = string
  
}