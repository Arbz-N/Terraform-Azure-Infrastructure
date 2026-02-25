output "config" {
    value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw

}
output "private_key" {
  value = tls_private_key.rsa_ssh_key.private_key_openssh
  sensitive = true
}

output "public_key" {
  value = tls_private_key.rsa_ssh_key.public_key_openssh
 }
