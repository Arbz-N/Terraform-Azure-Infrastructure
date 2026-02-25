**_Deploying AKS Cluster with Custom Terraform Modules**_

    This project is a production-ready, modular Terraform project for provisioning a fully automated Azure Kubernetes Service (AKS) cluster on Microsoft Azure.
    It leverages a clean module-based architecture to manage infrastructure components including a Service Principal, Azure Key Vault, and an AKS Cluster — 
    all wired together with proper RBAC, secret management, and remote state storage.

**_Key highlights:_**

    Automated Service Principal creation and credential management
    Globally unique Key Vault provisioning with RBAC authorization
    AKS cluster with autoscaling, SSH authentication, and Azure CNI networking
    Secure secret storage (SP credentials & SSH keys) in Key Vault
    Remote Terraform state backend on Azure Blob Storage

**_Project Structure_**

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

**_Prerequisites_**

    Before deploying this project, ensure the following tools and access are in place:
    
    Requirement                      Version/Detail
    Terraform                           >= 1.9.0
    Azure CLI                           Latest
    Azure Subscription                  Active with sufficient permissions
    Azure AD Permissions                Ability to create App Registrations & Service Principals
    Azure Storage Account               For Terraform remote backend (tfstate)