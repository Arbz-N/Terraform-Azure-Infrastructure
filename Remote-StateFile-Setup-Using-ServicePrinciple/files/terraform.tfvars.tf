service_principal = {
  client_id       = "<CLIENT_ID>"
  client_secret   = "<CLIENT_SECRET>"
  tenant_id       = "<TENANT_ID>"
  subscription_id = "<SUBSCRIPTION_ID>"
}

resource_group_details = {
  name     = "<RESOURCE_GROUP_NAME>"
  location = "<LOCATION>"
}

storge_account_details = {
  name                     = "<STORAGE_ACCOUNT_NAME>"
  account_replication_type = "GRS"
  account_tier             = "Standard"
}
