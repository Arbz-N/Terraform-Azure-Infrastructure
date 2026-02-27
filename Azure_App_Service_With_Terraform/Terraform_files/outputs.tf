output "production_url" {
  value = "https://${azurerm_linux_web_app.as.default_hostname}"
}

output "staging_url" {
  value = "https://${azurerm_linux_web_app_slot.slot.default_hostname}"
}