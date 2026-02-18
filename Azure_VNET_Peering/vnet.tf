resource "azurerm_virtual_network" "vnet1" {
  name                = var.vnet-1_details.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [var.vnet-1_details.address_space]
}

resource "azurerm_virtual_network" "vnet2" {
  name                = var.vnet-2_details.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = var.vnet-2_details.address_space
}

