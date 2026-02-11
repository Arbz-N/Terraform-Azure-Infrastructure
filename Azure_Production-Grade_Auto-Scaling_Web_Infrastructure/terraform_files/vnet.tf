resource "random_pet" "lb_hostname" {}

resource "azurerm_resource_group" "rg" {
  location = "<REGION>"
  name     = "<RESOURCE_GROUP_NAME>"
}

resource "azurerm_virtual_network" "vnet" {
  location            = azurerm_resource_group.rg.location
  name                = "<VNET_NAME>"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  address_prefixes     = ["10.0.0.0/20"]
  name                 = "<SUBNET_NAME>"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_network_security_group" "nsg" {
  location            = azurerm_resource_group.rg.location
  name                = "<NSG_NAME>"
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
  name                       = "allow-http-from-lb"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "80"
  source_address_prefix      = "AzureLoadBalancer"
  destination_address_prefix = "*"
}

  security_rule {
    name                       = "allow-https-from-lb"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }
  #ssh security rule
  security_rule {
    name                       = "allow-ssh-from-nat"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  security_rule {
  name                       = "allow-outbound-internet"
  priority                   = 200
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  destination_address_prefix = "*"
}

}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  network_security_group_id = azurerm_network_security_group.nsg.id
  subnet_id                 = azurerm_subnet.subnet.id
}

#  Public IP for Load Balancer
resource "azurerm_public_ip" "lb_pip" {
  allocation_method   = "Static"
  location            = azurerm_resource_group.rg.location
  name                = "<LB_PUBLIC_IP_NAME>"
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  zones               = ["1","2","3"]
  domain_name_label   = "<DNS_LABEL>-${random_pet.lb_hostname.id}"
}

resource "azurerm_lb" "lb" {
  location            = azurerm_resource_group.rg.location
  name                = "<LOAD_BALANCER_NAME>"
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "<FRONTEND_CONFIG_NAME>"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bepool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "<BACKEND_POOL_NAME>"
}

resource "azurerm_lb_probe" "probe" {
  name            = "http-probe"
  loadbalancer_id = azurerm_lb.lb.id
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

resource "azurerm_lb_rule" "http_rule" {
  backend_port                   = 80
  frontend_port                  = 80
  protocol                       = "Tcp"
  name                           = "http"
  loadbalancer_id                = azurerm_lb.lb.id
  frontend_ip_configuration_name = "<FRONTEND_CONFIG_NAME>"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bepool.id]
  probe_id                       = azurerm_lb_probe.probe.id
}

#  Public IP for NAT Gateway
resource "azurerm_public_ip" "natgw_pip" {
  name                = "<NATGW_PUBLIC_IP_NAME>"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

resource "azurerm_nat_gateway" "natgw" {
  name                    = "<NAT_GATEWAY_NAME>"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

resource "azurerm_nat_gateway_public_ip_association" "natgw_assoc" {
  public_ip_address_id = azurerm_public_ip.natgw_pip.id
  nat_gateway_id       = azurerm_nat_gateway.natgw.id
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat" {
  subnet_id      = azurerm_subnet.subnet.id
  nat_gateway_id = azurerm_nat_gateway.natgw.id
}
