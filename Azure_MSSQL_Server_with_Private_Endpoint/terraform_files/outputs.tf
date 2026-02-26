output "vm_public_ip" {
  value = azurerm_public_ip.vm_pip.ip_address
}
output "sql_private_ip" {
  value = azurerm_private_endpoint.sql_pe.private_service_connection[0].private_ip_address
}
output "sql_server_fqdn" {
  value = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}
output "ssh_command" {
  value = "ssh -i vm-private-key.pem azureuser@${azurerm_public_ip.vm_pip.ip_address}"
}