terraform {
  backend "azurerm" {
    resource_group_name  = "<YOUR_TFSTATE_RG_NAME>"
    storage_account_name = "<YOUR_STORAGE_ACCOUNT_NAME>"
    container_name       = "<YOUR_CONTAINER_NAME>"
    key                  = "<ENVIRONMENT>.terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.32.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }

  required_version = ">= 1.9.0"
}

