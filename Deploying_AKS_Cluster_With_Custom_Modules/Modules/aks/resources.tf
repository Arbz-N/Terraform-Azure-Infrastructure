# Generate an SSH key pair locally for AKS node authentication
resource "tls_private_key" "rsa_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Fetch the latest stable Kubernetes version available in the selected Azure region
data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location
  include_preview = false
}

# Create the Azure Kubernetes Service (AKS) cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "practice-aks-cluster"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.resource_group_name}-cluster"

  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version

  node_resource_group = "${var.resource_group_name}-nrg"

  oidc_issuer_enabled = true

  default_node_pool {
    name       = "defaultpool"
    vm_size    = "Standard_D2s_v3"
    zones      = [1, 3]

    auto_scaling_enabled = true
    min_count            = 1
    max_count            = 3

    os_disk_size_gb = 30
    type            = "VirtualMachineScaleSets"

    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "prod"
      "nodepoolos"    = "linux"
    }

    tags = {
      "nodepool-type" = "system"
      "environment"   = "prod"
      "nodepoolos"    = "linux"
    }
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = tls_private_key.rsa_ssh_key.public_key_openssh
    }
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}

# Save the generated private key locally for SSH access
resource "local_file" "private_key" {
  content         = tls_private_key.rsa_ssh_key.private_key_pem
  filename        = "${path.module}/aks-private-key.pem"
  file_permission = "0600"
}