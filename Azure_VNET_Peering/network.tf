resource "azurerm_resource_group" "rg" {
  location = "<REGION>"
  name     = "<RESOURCE_GROUP_NAME>"
}

resource "azurerm_virtual_network" "vnet1" {
  location            = azurerm_resource_group.rg.location
  name                = "<VNET1_NAME>"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["<VNET1_ADDRESS_SPACE>"]   # e.g. 10.0.0.0/16
}

resource "azurerm_subnet" "subnet1" {
  address_prefixes     = ["<SUBNET1_PREFIX>"]       # e.g. 10.0.0.0/24
  name                 = "<SUBNET1_NAME>"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
}

resource "azurerm_virtual_network" "vnet2" {
  location            = azurerm_resource_group.rg.location
  name                = "<VNET2_NAME>"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["<VNET2_ADDRESS_SPACE>"]   # e.g. 10.1.0.0/16
}

resource "azurerm_subnet" "subnet2" {
  address_prefixes     = ["<SUBNET2_PREFIX>"]       # e.g. 10.1.0.0/24
  name                 = "<SUBNET2_NAME>"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
}

resource "azurerm_virtual_network_peering" "vnet1_to_vnet2" {
  name                      = "<PEERING_NAME_1>"
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet1.name
}

resource "azurerm_virtual_network_peering" "vnet2_to_vnet1" {
  name                      = "<PEERING_NAME_2>"
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet2.name
}
