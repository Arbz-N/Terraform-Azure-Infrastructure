# Fetch details about the currently authenticated Azure AD user/service principal
data "azuread_client_config" "current" {}

# Create an Azure AD Application (logical identity / app registration)
resource "azuread_application" "main" {
  display_name = "<SERVICE_PRINCIPAL_NAME>"   # Placeholder for app name
  owners       = [data.azuread_client_config.current.object_id]
}

# Create a Service Principal linked to the above Application
resource "azuread_service_principal" "main" {
  client_id                     = azuread_application.main.client_id
  app_role_assignment_required   = true
  owners                         = [data.azuread_client_config.current.object_id]
}

# Generate a password/secret for the service principal
resource "azuread_service_principal_password" "main" {
  service_principal_id = azuread_service_principal.main.id
  value                = "<SERVICE_PRINCIPAL_SECRET>"   # Placeholder for secret
  end_date             = "2099-12-31T23:59:59Z"         # Example expiry date
}

