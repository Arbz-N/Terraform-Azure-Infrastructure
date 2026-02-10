# Day 6/28 - Terraform File And Directory Structure Best Practices

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.32.0"
    }
  }
  required_version = ">=1.9.0"
}
provider "azurerm" {
  features {}
  subscription_id = var.service_principal.subscription_id
  client_id = var.service_principal.client_id
  client_secret = var.service_principal.client_secret
  tenant_id = var.service_principal.tenant_id
}


