terraform {
  backend "azurerm" {
    resource_group_name  = "<TF_STATE_RESOURCE_GROUP>"
    storage_account_name = "<TF_STATE_STORAGE_ACCOUNT>"
    container_name       = "<TF_STATE_CONTAINER>"
    key                  = "dev.terraform.tfstate"
  }


