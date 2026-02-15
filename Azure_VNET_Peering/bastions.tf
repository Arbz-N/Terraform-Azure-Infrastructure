# Public IPs
resource "azurerm_public_ip" "bastion_ip_vm1" {
  name                = "bastion-ip-vm1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "bastion_ip_vm2" {
  name                = "bastion-ip-vm2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Bastion Hosts
resource "azurerm_bastion_host" "bastion_vm1" {
  name                = "bastion-vm1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = azurerm_subnet.vnet1_bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_ip_vm1.id
  }
}

resource "azurerm_bastion_host" "bastion_vm2" {
  name                = "bastion-vm2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = azurerm_subnet.vnet2_bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_ip_vm2.id
  }
}

