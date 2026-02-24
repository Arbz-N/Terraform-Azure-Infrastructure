# Generate an SSH private key locally that will be used for AKS node login
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Fetch available AKS Kubernetes versions for the selected Azure region
data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location
  include_preview = false
}

# Create the Azure Kubernetes Service (AKS) cluster
resource "azurerm_kubernetes_cluster" "aks" {

  # Basic cluster settings
  location            = var.location
  name                = "<AKS_CLUSTER_NAME>"
  resource_group_name = var.resource_group_name
  dns_prefix          = "<DNS_PREFIX>"

  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version

  # Managed resource group for AKS infrastructure
  node_resource_group = "<NODE_RESOURCE_GROUP_NAME>"

  # Default worker node pool configuration
  default_node_pool {
    name                  = "defaultpool"
    vm_size               = "<VM_SIZE>"
    zones                 = [1,2,3]

    auto_scaling_enabled  = true
    min_count             = 1
    max_count             = 3

    os_disk_size_gb       = 30
    type                  = "VirtualMachineScaleSets"

    node_labels = {
      "nodepool-type" = "<NODEPOOL_TYPE>"
      "environment"   = "<ENVIRONMENT>"
      "nodepoolos"    = "linux"
    }

    tags = {
      "nodepool-type" = "<NODEPOOL_TYPE>"
      "environment"   = "<ENVIRONMENT>"
      "nodepoolos"    = "linux"
    }
  }

  # Service principal used by AKS to manage Azure resources
  service_principal {
    client_id     = "<AZURE_CLIENT_ID>"
    client_secret = "<AZURE_CLIENT_SECRET>"
  }

  # Linux admin settings for nodes
  linux_profile {
    admin_username = "<SSH_USERNAME>"

    ssh_key {
      key_data = tls_private_key.ssh_key.public_key_openssh
    }
  }

  # Cluster networking configuration
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}

