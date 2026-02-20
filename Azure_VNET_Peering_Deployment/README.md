**_Azure VNET Peering Deployment with Terraform_**

    Project Overview

    This project automates the creation of Azure Virtual Networks (VNETs), subnets, bastion hosts, network interfaces, virtual machines, and VNET peering using Terraform.
    The purpose of this project is to simplify and standardize network and compute infrastructure in Azure.
    It allows you to:
    Quickly deploy multiple VNETs and interconnect them with VNET peering, enabling secure communication between networks.
    Set up subnets for VMs and Bastion hosts in a modular and reusable manner.
    Deploy virtual machines in a secure and consistent way, with configurable OS, storage, and networking.
    Provision Azure Bastion hosts to securely connect to VMs without exposing them to public IPs.
    Manage infrastructure as code, making deployments repeatable, auditable, and easy to maintain.
    This setup is especially useful in multi-environment scenarios, such as dev, staging, and production,
    where isolated networks need to communicate securely. It also demonstrates best practices for Infrastructure as Code (IaC) using Terraform in Azure.

**_Project Structure_**

    terraform_files/
        ├── bastions.tf          # Deploys Bastion hosts and their public IPs
        ├── peering.tf           # Configures VNET peering between networks
        ├── provider.tf          # Configures Azure provider and authentication
        ├── resource_group.tf    # Creates resource groups in Azure
        ├── subnets.tf           # Creates subnets for VNETs and Bastion
        ├── terraform.tf         # Terraform backend & provider configuration
        ├── terraform.tfvars     # Contains variable values (sensitive info replaced with placeholders)
        ├── variables.tf         # Declares all project variables
        ├── vms.tf               # Deploys virtual machines and their network interfaces
        ├── vnet.tf              # Deploys virtual networks (VNETs)


**_Prerequisites**_

    Terraform >= 1.9.0
    Azure CLI installed and authenticated
    Azure Subscription with sufficient permissions
    Service Principal for programmatic deployment

**_How It Works_**

    Resource Groups: All resources are deployed into configurable resource groups.
    Virtual Networks (VNETs): Creates multiple VNETs with user-defined address spaces.
    Subnets: Each VNET has subnets for VMs and a dedicated subnet for Bastion hosts.
    Network Interfaces: Configures NICs for virtual machines and connects them to their subnets.
    Virtual Machines (VMs): Deploys Linux VMs with configurable OS, storage, and networking.
    Bastion Hosts: Deploys Bastion hosts in dedicated subnets to allow secure RDP/SSH access without public IPs on VMs.
    VNET Peering: Connects multiple VNETs for seamless and secure inter-network communication.
    Dynamic & Modular: The entire deployment uses for_each loops, maps, and objects for easy scalability and multi-environment support.


**_Deployment Steps**_

    Initialize Terraform:
    terraform init
    
    Plan the deployment:
    terraform plan -var-file="terraform.tfvars"
    
    Apply the configuration:
    terraform apply -var-file="terraform.tfvars"
    
    
    Destroy the deployment (when no longer needed):
    terraform destroy -var-file="terraform.tfvars"

**_Variables & Sensitive Data_**

    Sensitive data such as service principal credentials are managed via terraform.tfvars with placeholders:
    
    service_principal = {
      client_id       = "<CLIENT_ID>"
      client_secret   = "<CLIENT_SECRET>"
      tenant_id       = "<TENANT_ID>"
      subscription_id = "<SUBSCRIPTION_ID>"
    }


**_Other variables include:_**

    vnets – VNET names and address spaces
    vnets_subnet – Subnets within each VNET
    bastion_subnet – Dedicated Bastion subnets
    vms – VM specifications including OS, storage, and network interfaces
    nics – Network interface definitions
    peering – Defines VNET peering relationships
    ips_for_bastion – Public IPs for Bastion hosts
    bastion_vms – Bastion host definitions