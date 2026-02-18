# Application Subnets
resource "azurerm_subnet" "vnets_subnet" {
  for_each = var.vnets_subnet

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet[each.value.vnet_name].name
  address_prefixes     = [each.value.address_prefixes]
}

# Bastion Subnets
resource "azurerm_subnet" "bastion_subnet" {
  for_each = var.bastion_subnet

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet[each.value.vnet_name].name
  address_prefixes     = [each.value.address_prefixes]
}
