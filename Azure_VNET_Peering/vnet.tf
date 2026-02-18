resource "azurerm_virtual_network" "vnet" {
  for_each = var.vnets
  name                = each.value.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [each.value.address_space]
}


