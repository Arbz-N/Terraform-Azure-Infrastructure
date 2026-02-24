# Fetch details of the currently authenticated Azure identity
data "azuread_client_config" "current" {}
# This data source fetches information about the Azure AD identity
# that Terraform is currently using, including object_id, tenant_id, and client_id.
# These are useful for ownership and access control.

# Create an Azure Key Vault
resource "azurerm_key_vault" "kv" {

  location = "<KEYVAULT_LOCATION>"                # Azure region where the Key Vault will be deployed, e.g., "eastus"
  name = "<KEYVAULT_NAME>"                        # Unique Key Vault name (must be globally unique in Azure)
  resource_group_name = "<RESOURCE_GROUP_NAME>"   # Resource Group in which the Key Vault will be created
  tenant_id = "<SERVICE_PRINCIPAL_TENANT_ID>"     # Tenant ID that owns the Key Vault
  sku_name = "premium"                            # Premium SKU allows HSM-backed keys and advanced features

  purge_protection_enabled = false                # If true, deleted Key Vault cannot be purged; false disables purge protection
  soft_delete_retention_days = 7                  # Number of days a deleted Vault can be recovered (minimum is 7)
  enable_rbac_authorization = true               # Enables Azure RBAC based access control instead of access policies
  enabled_for_disk_encryption = true             # Allows Azure Disk Encryption to use this Key Vault
}

