output "lb_ip" {
  value = azurerm_public_ip.lb_pip.ip_address
}
