service_principal = {
  client_id       = "<CLIENT_ID>"
  client_secret   = "<CLIENT_SECRET>"
  tenant_id       = "<TENANT_ID>"
  subscription_id = "<SUBSCRIPTION_ID>"
}

rg_details = {
  name     = "<RESOURCE_GROUP_NAME>"
  location = "<LOCATION>"
}

storage_account_details = {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  name                     = "<STORAGE_ACCOUNT_NAME>"
}

service_plan_details = {
  name     = "<SERVICE_PLAN_NAME>"
  os_type  = "Linux"
  sku_name = "<SKU_NAME>"
}

func_details = {
  name         = "<FUNCTION_APP_NAME>"
  node_version = "<NODE_VERSION>"
  functions_extension_version = "~4"
  WEBSITE_RUN_FROM_PACKAGE = "1"
}