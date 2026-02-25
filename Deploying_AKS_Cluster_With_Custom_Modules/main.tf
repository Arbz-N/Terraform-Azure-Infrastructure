# -----------------------------------------------------------
# Resource Group
# -----------------------------------------------------------
resource "azurerm_resource_group" "rg1" {
  name     = var.rg_details.name
  location = var.rg_details.location
}

# Current Azure identity info
data "azuread_client_config" "current" {}

# -----------------------------------------------------------
# Service Principal module
# -----------------------------------------------------------
module "ServicePrincipal" {
  source                 = "./modules/ServicePrincipal"
  service_principal_name = var.service_principal_name

  depends_on = [
    azurerm_resource_group.rg1
  ]
}

# -----------------------------------------------------------
# Give SP Contributor access to subscription
# -----------------------------------------------------------
resource "azurerm_role_assignment" "rolespn" {

  scope = "/subscriptions/${var.SUBSCRIPTION_ID_PLACEHOLDER}"

  role_definition_name = "Contributor"

  principal_id = module.ServicePrincipal.service_principal_object_id

  depends_on = [
    module.ServicePrincipal
  ]
}

# -----------------------------------------------------------
# Random suffix for globally unique Key Vault name
# -----------------------------------------------------------
resource "random_id" "rand_id" {
  byte_length = var.random_length
}

# -----------------------------------------------------------
# Key Vault module
# -----------------------------------------------------------
module "key_vault" {
  source = "./modules/keyvault"

  keyvault_details = {
    keyvault_name               = "${var.keyvault_name}-${substr(random_id.rand_id.hex,0,6)}"
    location                    = var.rg_details.location
    resource_group_name         = var.rg_details.name
    service_principal_name      = var.service_principal_name
    service_principal_object_id = module.ServicePrincipal.service_principal_object_id
    service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id
  }

  depends_on = [
    module.ServicePrincipal
  ]
}

# -----------------------------------------------------------
# Allow SP to manage secrets in Key Vault
# -----------------------------------------------------------
resource "azurerm_role_assignment" "eks_sp_kv" {
  scope                = module.key_vault.keyvault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = module.ServicePrincipal.service_principal_object_id

  depends_on = [
    module.key_vault
  ]
}

# Allow current user access to Key Vault
resource "azurerm_role_assignment" "current_user_kv" {
  scope                = module.key_vault.keyvault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azuread_client_config.current.object_id

  depends_on = [
    module.key_vault
  ]
}

# Wait for RBAC propagation
resource "time_sleep" "wait_for_rbac" {
  create_duration = "90s"

  depends_on = [
    azurerm_role_assignment.eks_sp_kv,
    azurerm_role_assignment.current_user_kv
  ]
}

# -----------------------------------------------------------
# Store SP credentials securely in Key Vault
# -----------------------------------------------------------
resource "azurerm_key_vault_secret" "s_principal" {
  name         = module.ServicePrincipal.client_id
  value        = module.ServicePrincipal.client_secret
  key_vault_id = module.key_vault.keyvault_id

  depends_on = [
    module.key_vault,
    azurerm_role_assignment.eks_sp_kv,
    time_sleep.wait_for_rbac
  ]
}

# Store AKS SSH private key securely in Key Vault
resource "azurerm_key_vault_secret" "ssh_key" {
  key_vault_id = module.key_vault.keyvault_id
  name         = "aks-node-private-key"
  value        = module.aks.private_key

  depends_on = [
    azurerm_role_assignment.eks_sp_kv,
    module.key_vault,
    time_sleep.wait_for_rbac
  ]
}

# -----------------------------------------------------------
# AKS module
# -----------------------------------------------------------
module "aks" {
  source                 = "./modules/aks/"
  service_principal_name = var.service_principal_name
  client_id              = module.ServicePrincipal.client_id
  client_secret          = module.ServicePrincipal.client_secret
  location               = var.rg_details.location
  resource_group_name    = var.rg_details.name

  depends_on = [
    module.ServicePrincipal
  ]
}

# -----------------------------------------------------------
# Save kubeconfig locally
# -----------------------------------------------------------
resource "local_file" "kubeconfig" {
  filename  = "./kubeconfig"
  content   = module.aks.config
  depends_on = [module.aks]
}