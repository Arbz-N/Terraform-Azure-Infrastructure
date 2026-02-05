locals {
  environment = "prod"
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_details.name
  location = var.resource_group_details.location
}

resource "azurerm_storage_account" "example" {
  name                     = var.storge_account_details.name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = var.storge_account_details.account_tier
  account_replication_type = var.storge_account_details.account_replication_type

  tags = {
    environment = local.environment
  }
}
