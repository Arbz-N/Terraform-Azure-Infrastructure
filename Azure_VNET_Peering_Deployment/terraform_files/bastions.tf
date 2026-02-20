# Public IPs
resource "azurerm_public_ip" "ip_for_bastion" {
  for_each = var.ips_for_bastion

  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  name = each.value.name
  allocation_method   = each.value.allocation_method
  sku = each.value.sku
}


# Bastion Hosts
resource "azurerm_bastion_host" "bastion_vms" {
  for_each = var.bastion_vms
  name                = each.value.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                 = each.value.ip_name
    subnet_id            = azurerm_subnet.bastion_subnet[each.value.subnet_key].id
    public_ip_address_id = azurerm_public_ip.ip_for_bastion[each.value.ip_address_key].id
  }
}


