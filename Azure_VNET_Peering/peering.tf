resource "azurerm_virtual_network_peering" "peerings" {
  for_each = var.peering

  depends_on = [azurerm_virtual_network.vnet]
  name                      = each.key
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet[each.value.source].name
  remote_virtual_network_id = azurerm_virtual_network.vnet[each.value.target].id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}