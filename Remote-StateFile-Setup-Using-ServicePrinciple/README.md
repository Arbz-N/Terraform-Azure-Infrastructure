**Remote-StateFile-Setup-Using-ServicePrinciple**

Overview

    This project demonstrates how to configure a production-style Terraform workflow in Microsoft Azure using a Service Principal for authentication and Azure Blob Storage as a remote backend. 
    The approach follows Infrastructure as Code (IaC) and DevOps best practices by separating resource provisioning from state management and using non-human automation identities.
    The workflow ensures secure, centralized state storage and reproducible infrastructure deployment.

Architecture Flow

    Service Principal → Provides Automation Authentication
    Azure CLI / Terraform → Creates Backend Storage (Resource Group, Storage Account, Container)
    Terraform → Deploys Infrastructure
    Azure Blob Storage → Stores Terraform State File

Prerequisites

Before starting, ensure you have:

    Azure Subscription
    Azure CLI installed and logged in
    Terraform v1.9+ installed
    Permissions to create:
    
    Azure AD Service Principals  #to create azure resources
    Resource Groups
    Storage Accounts

Step 1 — Create Service Principal for Automation
First, create a Service Principal that Terraform and scripts can use for authentication:

    az ad sp create-for-rbac -n az-demo --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"

    Example output:
    
    {
      "appId": "<CLIENT_ID>",
      "displayName": "az-demo",
      "password": "<CLIENT_SECRET>",
      "tenant": "<TENANT_ID>"
    }

    Use these credentials in Terraform provider configuration.

Step 2 — Create Remote State Storage (Using CLI or Terraform)

    Once the Service Principal exists, you can create backend resources:

    #!/bin/bash
    
    RESOURCE_GROUP_NAME=tfstate-day04
    STORAGE_ACCOUNT_NAME=day04$RANDOM
    CONTAINER_NAME=tfstate
    
    # Create resource group
    az group create --name $RESOURCE_GROUP_NAME --location eastus
    
    # Create storage account
    az storage account create \
      --resource-group $RESOURCE_GROUP_NAME \
      --name $STORAGE_ACCOUNT_NAME \
      --sku Standard_LRS \
      --encryption-services blob
    
    # Create blob container
    az storage container create \
      --name $CONTAINER_NAME \
      --account-name $STORAGE_ACCOUNT_NAME
    
    These resources will store Terraform’s state file securely in Azure.

Step 3 — Terraform Provider Configuration

    Terraform uses the Service Principal credentials:
    
    provider "azurerm" 
      features {}
    
      subscription_id = "<SUBSCRIPTION_ID>"
      client_id       = "<CLIENT_ID>"
      client_secret   = "<CLIENT_SECRET>"
      tenant_id       = "<TENANT_ID>"
    }

Step 4 — Remote Backend Configuration

    Terraform state is stored remotely in Azure Blob Storage:
    
    terraform {
      backend "azurerm" {
        resource_group_name  = "<TF_STATE_RESOURCE_GROUP>"
        storage_account_name = "<TF_STATE_STORAGE_ACCOUNT>"
        container_name       = "<TF_STATE_CONTAINER>"
        key                  = "dev.terraform.tfstate"
      }
    }

Benefits of This Setup

    Secure automation using Service Principals
    Centralized Terraform state management
    Team collaboration ready
    Reproducible infrastructure deployment
    Production-grade Terraform workflow

Deployment Commands

    terraform init
    terraform plan
    terraform apply
    terraform destroy

Terraform state will now be securely stored in Azure Blob Storage.

For practice/demo purposes only — make sure to delete this after use