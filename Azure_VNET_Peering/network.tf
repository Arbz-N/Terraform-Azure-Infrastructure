resource "azurerm_resource_group" "r-group" {
  location = "australiaeast"
  name     = "practice"
}

resource "azurerm_virtual_network" "vnet1" {
  location            = azurerm_resource_group.r-group.location
  name                = "vnet-1"
  resource_group_name = azurerm_resource_group.r-group.name
  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet-1" {
  address_prefixes = ["10.0.0.0/24"]
  name                 = "subnet-peer1"
  resource_group_name  = azurerm_resource_group.r-group.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
}

resource "azurerm_virtual_network" "vnet2" {
  location            = azurerm_resource_group.r-group.location
  name                = "vnet-2"
  resource_group_name = azurerm_resource_group.r-group.name
  address_space = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "subnet-2" {
  address_prefixes = ["10.0.1.0/24"]
  name                 = "subnet-peer1"
  resource_group_name  = azurerm_resource_group.r-group.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
}
resource "azurerm_virtual_network_peering" "peering-1" {
  name                      = "peeringVnet-1-to-2"
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
  resource_group_name       = azurerm_resource_group.r-group.name
  virtual_network_name      = azurerm_virtual_network.vnet1.name
}

resource "azurerm_virtual_network_peering" "peering-2" {
  name                      = "peeringVnet-2-to-1"
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
  resource_group_name       = azurerm_resource_group.r-group.name
  virtual_network_name      = azurerm_virtual_network.vnet2.name
}

