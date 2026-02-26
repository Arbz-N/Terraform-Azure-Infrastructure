# Deploying AKS Cluster with Custom Terraform Modules

    This project is a production-ready, modular Terraform project for provisioning a fully automated Azure Kubernetes Service (AKS) cluster on Microsoft Azure.
    It leverages a clean module-based architecture to manage infrastructure components including a Service Principal, Azure Key Vault, and an AKS Cluster — 
    all wired together with proper RBAC, secret management, and remote state storage.

## Key highlights:

    Automated Service Principal creation and credential management
    Globally unique Key Vault provisioning with RBAC authorization
    AKS cluster with autoscaling, SSH authentication, and Azure CNI networking
    Secure secret storage (SP credentials & SSH keys) in Key Vault
    Remote Terraform state backend on Azure Blob Storage

## Project Structure

    Deploying_AKS_Cluster_With_Custom_Modules/
    │
    ├── modules/
    │   ├── aks/
    │   │   ├── outputs.tf          # AKS cluster outputs (kubeconfig, SSH keys)
    │   │   ├── resources.tf        # AKS cluster, SSH key pair, node pool config
    │   │   └── variables.tf        # AKS module input variables
    │   │
    │   ├── keyvault/
    │   │   ├── outputs.tf          # Key Vault ID output
    │   │   ├── resources.tf        # Azure Key Vault resource definition
    │   │   └── variables.tf        # Key Vault module input variables
    │   │
    │   └── ServicePrincipal/
    │       ├── outputs.tf          # SP name, object ID, tenant ID, client credentials
    │       ├── resources.tf        # AAD App, Service Principal, and password
    │       └── variables.tf        # SP module input variables
    │
    ├── main.tf                     # Root module — orchestrates all child modules
    ├── outputs.tf                  # Root-level outputs (RG name, client ID, secret)
    ├── terraform.tf                # Terraform backend, provider versions, requirements
    ├── terraform.tfvars            # Variable values (replace placeholders before use)
    ├── variables.tf                # Root-level variable declarations
    └── README.md                   # Project documentation


## Architecture

    ┌─────────────────────────────────────────────────────────┐
    │                   Azure Subscription                    │
    │                                                         │
    │  ┌───────────────────────────────────────────────────┐  │
    │  │                  Resource Group                   │  │
    │  │                                                   │  │
    │  │  ┌─────────────────┐     ┌─────────────────────┐  │  │
    │  │  │   Entra ID      │     │     Key Vault       │  │  │
    │  │  │                 │     │                     │  │  │
    │  │  │  ┌───────────┐  │     │  ┌───────────────┐  │  │  │
    │  │  │  │    AAD    │  │     │  │  SP Secret    │  │  │  │
    │  │  │  │    App    │  │     │  │  SSH Key      │  │  │  │
    │  │  │  └─────┬─────┘  │     │  └───────────────┘  │  │  │
    │  │  │        │        │     │                     │  │  │
    │  │  │  ┌─────▼─────┐  │     │                     │  │  │
    │  │  │  │  Service  │──┼─────►  Secrets Officer    │  │  │
    │  │  │  │ Principal │  │     │  (RBAC Role)        │  │  │
    │  │  │  └─────┬─────┘  │     └─────────────────────┘  │  │
    │  │  └────────┼────────┘               │              │  │
    │  │           │                        │              │  │
    │  │           │ Contributor Role       │              │  │
    │  │           ▼                        ▼              │  │
    │  │  ┌─────────────────────────────────────────────┐  │  │
    │  │  │               AKS Cluster                   │  │  │
    │  │  │                                             │  │  │
    │  │  │         ┌─────────────────────┐             │  │  │
    │  │  │         │   Default Node Pool │             │  │  │
    │  │  │         │   (AutoScale 1–3)   │             │  │  │
    │  │  │         └─────────────────────┘             │  │  │
    │  │  └─────────────────────────────────────────────┘  │  │
    │  └───────────────────────────────────────────────────┘  │
    └─────────────────────────────────────────────────────────┘
                              │
                              │ terraform init / remote state
                              ▼
              ┌───────────────────────────────┐
              │       Azure Blob Storage      │
              │   (Remote Terraform State)    │
              └───────────────────────────────┘

## Prerequisites

    Before deploying this project, ensure the following tools and access are in place:
    
    Requirement                      Version/Detail
    Terraform                           >= 1.9.0
    Azure CLI                           Latest
    Azure Subscription                  Active with sufficient permissions
    Azure AD Permissions                Ability to create App Registrations & Service Principals
    Azure Storage Account               For Terraform remote backend (tfstate)

## Module Explanation

    1. modules/ServicePrincipal

    This module creates an Azure Active Directory (AAD) Application and an associated Service Principal along with a password/secret.
    What it does:
    
    Registers an AAD Application under the currently authenticated identity
    Creates a Service Principal linked to that application
    Generates a long-lived secret (valid until 2099)
    Outputs client_id, client_secret, object_id, and tenant_id for use by other modules

    Why it's needed: The Service Principal acts as the identity through which AKS and other resources are managed programmatically.

    2. modules/keyvault

    This module provisions an Azure Key Vault with RBAC-based authorization, used to securely store secrets generated by other modules.
    What it does:
    
    Creates a Key Vault with a random suffix to ensure global name uniqueness
    Enables RBAC authorization (instead of legacy access policies)
    Enables soft-delete (7-day retention) and disk encryption support
    Uses Premium SKU for HSM-backed key support
    
    Why it's needed: Secrets like the SP client secret and AKS SSH private key must be stored securely and not left in Terraform state alone.

    3. modules/aks
    
    This module deploys the core Azure Kubernetes Service (AKS) cluster.
    What it does:
    
    Generates an RSA 2048-bit SSH key pair for node authentication
    Fetches the latest stable Kubernetes version available in the region
    Creates an AKS cluster with:
    
    Autoscaling node pool (1–3 nodes, Standard_D2s_v3)
    Availability zones 1 and 3
    Azure CNI network plugin with Standard Load Balancer
    OIDC issuer enabled
    Linux nodes with SSH access
    Saves the SSH private key locally as aks-private-key.pem
    Outputs raw kubeconfig for use with kubectl


    4. Root main.tf
    
    The root module ties all child modules together and handles cross-module dependencies:
    
    Creates the Resource Group
    Calls the ServicePrincipal module
    Assigns the SP Contributor role at the subscription scope
    Calls the Key Vault module with a random suffix
    Grants SP and current user Key Vault Secrets Officer access
    Waits 90 seconds for RBAC propagation before writing secrets
    Stores SP credentials and AKS SSH key in Key Vault
    Calls the AKS module and saves kubeconfig locally


## Configuration — terraform.tfvars

    Before running, replace all placeholder values in terraform.tfvars:

    rg_details = {
      name     = "<YOUR_RESOURCE_GROUP_NAME>"
      location = "<AZURE_REGION>"             # e.g., "eastus"
    }

    service_principal_name = "<YOUR_SP_NAME>"
    random_length          = 4
    keyvault_name          = "<YOUR_KEYVAULT_BASE_NAME>"
    SUB_ID                 = "<YOUR_SUBSCRIPTION_ID>"
    Also update terraform.tf backend configuration:
    hclbackend "azurerm" {
      resource_group_name  = "<TFSTATE_RESOURCE_GROUP>"
      storage_account_name = "<STORAGE_ACCOUNT_NAME>"
      container_name       = "<CONTAINER_NAME>"
      key                  = "prod.terraform.tfstate"
    }

## Deployment

    # Step 1: Initialize Terraform (downloads providers, connects backend)
    terraform init
    
    # Step 2: Validate configuration
    terraform validate
    
    # Step 3: Preview infrastructure changes
    terraform plan -var-file="terraform.tfvars"
    
    # Step 4: Apply and provision infrastructure
    terraform apply -var-file="terraform.tfvars"

    After a successful apply, the kubeconfig file will be saved locally. 
    Use it to connect to your cluster:
    
    bashexport KUBECONFIG=./kubeconfig
    kubectl get nodes

    Destroy Infrastructure
    terraform destroy -var-file="terraform.tfvars"

    ⚠️ This will permanently delete all provisioned resources including the AKS cluster,
        Key Vault, and Service Principal.


## Security Notes

    Never commit terraform.tfvars, kubeconfig, or *.pem files to version control.
    Sensitive outputs (like client_secret) are marked sensitive = true in Terraform to prevent accidental exposure in logs.