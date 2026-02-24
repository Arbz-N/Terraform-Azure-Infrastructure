variable "rg_details" {
  type        = object({
    name = string
    location = string
  })
  description = "resource group configuration"

}

variable "service_principal_name" {
  type = string
  description = "Service_principal name"
}

variable "random_length" {
  type = number
}

variable "keyvault_name" {
  type = string
  description = "key_vault  name"
}

variable "SUB_ID" {
  type = string
}
