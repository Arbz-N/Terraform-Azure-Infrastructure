service_principal = {
  client_id       = "<CLIENT_ID>"
  client_secret   = "<CLIENT_SECRET>"
  tenant_id       = "<TENANT_ID>"
  subscription_id = "<SUBSCRIPTION_ID>"
}


vnet-1_details = {
  name = "vnet-1"
  address_space = "10.0.0.0/16"
}
vnet-2_details = {
  name = "vnet-2"
  address_space = "10.1.0.0/16"
}

# Infrastructure Configuration
location            = "eastus"
resource_group_name = "prod-web-infra-rg"
vm_size             = "Standard_B2s"
admin_username      = "azureuser"
ssh_public_key_path = "~/.ssh/azure_vm_key.pub"