#Fetch details of the currently authenticated Azure identity
data "azuread_client_config" "current" {}

# Create an Azure Key Vault
resource "azurerm_key_vault" "kv" {

  location = var.keyvault_details.location
  name = var.keyvault_details.keyvault_name
  resource_group_name = var.keyvault_details.resource_group_name
  tenant_id = var.keyvault_details.service_principal_tenant_id
  sku_name = "premium"
  purge_protection_enabled = false
  soft_delete_retention_days = 7
  enable_rbac_authorization = true
  enabled_for_disk_encryption = true
}
