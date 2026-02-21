resource "random_id" "example" {
  byte_length = var.random_length
}
resource "azurerm_resource_group" "example" {
  name     = var.rg_details.name
  location = var.rg_details.location
}

resource "azurerm_storage_account" "example" {
  name = lower("${var.storage_account_details.name}${random_id.example.hex}")

  location                 = azurerm_resource_group.example.location
  resource_group_name      = azurerm_resource_group.example.name
  account_tier             = var.storage_account_details.account_tier
  account_replication_type = var.storage_account_details.account_replication_type
}


resource "azurerm_service_plan" "example" {
  location            = azurerm_resource_group.example.location
  name                = var.service_plan_details.name
  os_type             = var.service_plan_details.os_type
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = var.service_plan_details.sku_name
}

resource "azurerm_linux_function_app" "example" {
  name = "${var.func_details.name}-${substr(random_id.example.hex,0,6)}"

  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_service_plan.example.id

  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key

  functions_extension_version = "~4"

  site_config {
    application_stack {
      node_version = var.func_details.node_version
    }
  }

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }
}