provider "azurerm" {
  features {}

  subscription_id = var.service_principal.subscription_id   # AZURE_SUBSCRIPTION_ID
  client_id       = var.service_principal.client_id          # AZURE_CLIENT_ID
  client_secret   = var.service_principal.client_secret      # AZURE_CLIENT_SECRET
  tenant_id       = var.service_principal.tenant_id          # AZURE_TENANT_ID
}
