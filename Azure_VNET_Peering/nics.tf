resource "azurerm_network_interface" "nics" {
  for_each = var.nics

  location            = azurerm_resource_group.rg.location
  name                = each.key
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = each.value.ip_name
    private_ip_address_allocation = each.value.private_ip_address_allocation
    subnet_id                     = azurerm_subnet.vnets_subnet[each.value.subnet_key].id
  }
}