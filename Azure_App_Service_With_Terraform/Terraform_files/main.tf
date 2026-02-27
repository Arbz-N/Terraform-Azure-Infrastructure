resource "azurerm_resource_group" "rg" {
  name = "${var.prefix}-rg"
  location = "canadacentral"
}
resource "azurerm_service_plan" "asp" {
  name                = "${var.prefix}-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  os_type  = "Linux"
  sku_name = "S1"
}

resource "azurerm_linux_web_app" "as" {
  name                = "${var.prefix}-webapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = false
  }
}

resource "azurerm_linux_web_app_slot" "slot" {
  name                = "${var.prefix}-staging"
  app_service_id      = azurerm_linux_web_app.as.id


  site_config {
    always_on = false
  }

}

resource "azurerm_app_service_source_control" "scm" {
  app_id   = azurerm_linux_web_app.as.id
  repo_url = "https://github.com/Arbz-N/Simple_Testing_App.git"
  branch   = "master"
  use_manual_integration = true
}

resource "azurerm_app_service_source_control_slot" "scm1" {
  slot_id   = azurerm_linux_web_app_slot.slot.id
  repo_url = "https://github.com/Arbz-N/Simple_Testing_App.git"
  branch   = "staging"
  use_manual_integration = true
}

resource "azurerm_web_app_active_slot" "active" {
  slot_id = azurerm_linux_web_app_slot.slot.id

}
