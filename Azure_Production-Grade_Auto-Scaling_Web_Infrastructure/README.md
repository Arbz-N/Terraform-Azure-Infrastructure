**_Azure Production-Grade Auto-Scaling Web Infrastructure_**

    Overview
    This project provides a production-ready, auto-scaling web infrastructure on Microsoft Azure, fully automated using Terraform. 
    It implements industry best practices for high availability, security, and operational excellence, making it ideal for deploying scalable web applications in enterprise environments.

_**Repository Structure**_

    Azure-Production-AutoScaling-WebInfra/
    │
    ├── terraform_files/
    │   ├── backend.tf          # Remote backend configuration (Azure Blob Storage)
    │   ├── provider.tf         # Azure provider authentication (Service Principal)
    │   ├── variables.tf        # Input variables definitions
    │   ├── terraform.tfvars    # Credentials (placeholders only)
    │   ├── vnet.tf             # VNet, Subnet, NSG, Load Balancer, NAT Gateway
    │   ├── vms.tf              # Virtual Machine Scale Set configuration
    │   ├── autoscale.tf        # CPU-based autoscaling rules
    │   ├── output.tf           # Output values (Load Balancer Public IP)
    │   └── user_data.sh        # VM startup script (Apache + PHP setup)
    │
    └── README.md


**_What You'll Deploy**_

    Virtual Network (VNet) with isolated subnets
    Azure Load Balancer for traffic distribution
    Virtual Machine Scale Sets (VMSS) with auto-scaling
    NAT Gateway for secure outbound connectivity
    Network Security Groups (NSG) for traffic control
    Azure Monitor Autoscale for dynamic resource adjustment
    Remote state management via Azure Blob Storage

**_Prerequisites**_

    Before deployment:
    Azure Subscription
    Azure CLI installed
    Terraform ≥ 1.9
    Service Principal with Contributor role
    SSH Key pair

**_Deployment Steps**_

    1 Generate SSH Key
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/azure_vm_key 
    
    This creates:
    Private key: ~/.ssh/azure_vm_key
    Public key: ~/.ssh/azure_vm_key.pub
    
    2 Create Service Principal
    az ad sp create-for-rbac -n az-demo --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"

    Save the output:
    json{
      "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "password": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
      "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    }
    
    3 Create Terraform Backend Storage
    az group create --name tfstate-day04 --location eastus
    az storage account create --resource-group tfstate-day04 --name <storage_name> --sku Standard_LRS
    az storage container create --name tfstate --account-name <storage_name>
    
    4 Deploy Infrastructure
    terraform init
    terraform plan
    terraform apply
    
    Get Application URL
    terraform output lb_ip
    
    
    Access your application:
    http://<lb_ip>/index.php

**_Key Features**_
    
      Feature                                                 Description
    High Availability                      Multi-instance deployment across availability zones
    Auto-Scaling                           Dynamic scaling based on CPU metrics (70% scale-out, 10% scale-in)
    Security First                         Zero public IPs on VMs, NSG-controlled traffic, NAT-based outbound
    Infrastructure as Code                 100% Terraform-managed, version-controlled infrastructure
    Load Balancing                         Health probe-based traffic distribution
    Zero Downtime                          Rolling updates and automated health checks
    Cost Optimized                         Scale-in capabilities reduce costs during low traffic
    Production Ready                       Service Principal authentication, remote state, modular design

**_Architecture Highlights**_

    Single Entry Point: All traffic flows through Azure Load Balancer
    Private VM Instances: No direct internet exposure
    Controlled Outbound: NAT Gateway for secure package downloads and updates
    Dynamic Scaling: Azure Monitor adjusts VM count based on demand
    Health Monitoring: Continuous health probes ensure traffic goes to healthy instances only
    
_**What This Project Demonstrates**_

    Production-grade Azure architecture
    Secure networking
    Load balancing
    Autoscaling infrastructure
    Infrastructure as Code (Terraform)
    Cloud security best practices



    
    