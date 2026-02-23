# Generate an SSH private key locally that will be used for AKS node login
resource "tls_private_key" "rsa-4096-example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Fetch available AKS Kubernetes versions for the selected Azure region
data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location
  include_preview = false
}

# Create the Azure Kubernetes Service (AKS) cluster
resource "azurerm_kubernetes_cluster" "aks-cluster" {

  # Basic cluster settings
  location            = var.location
  name                = "practice-aks-cluster"
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.resource_group_name}-cluster"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  # Automatically pick latest stable Kubernetes version

  node_resource_group = "${var.resource_group_name}-nrg"
  # Separate managed resource group where Azure stores cluster infra (VMSS, disks, LB etc.)

  # Default worker node pool configuration
  default_node_pool {
    name                  = "defaultpool"
    vm_size               = "Standard_D2s_v3"
    zones                 = [1,2,3]

    auto_scaling_enabled  = true
    min_count             = 1
    max_count             = 3

    os_disk_size_gb       = 30
    type                  = "VirtualMachineScaleSets"
    # Required for autoscaling in AKS

    # Labels attached to Kubernetes nodes (visible inside K8s)
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "prod"
      "nodepoolos"    = "linux"
    }

    # Azure resource tags (visible in Azure portal)
    tags = {
      "nodepool-type" = "system"
      "environment"   = "prod"
      "nodepoolos"    = "linux"
    }
  }

  # Service principal used by AKS to manage Azure resources
  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  # Linux admin settings for nodes
  linux_profile {
    admin_username = "ubuntu"   # SSH username for node login

    ssh_key {
      # SSH public key used to access nodes
      key_data = tls_private_key.rsa-4096-example.private_key_openssh
    }
  }

  # Cluster networking configuration
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}

