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

resource "azurerm_virtual_machine" "vm" {
  for_each = var.vms

  name                = each.value.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_size             = each.value.vm_size

  # ✅ Correct NIC reference
  network_interface_ids = [
    azurerm_network_interface.nics[each.value.nic_id].id
  ]

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = each.value.image.publisher
    offer     = each.value.image.offer
    sku       = each.value.image.sku
    version   = each.value.image.version
  }

  storage_os_disk {
    name              = each.value.storage.name
    caching           = each.value.storage.caching
    create_option     = each.value.storage.create_option
    managed_disk_type = each.value.storage.managed_disk_type
  }

  os_profile {
    computer_name  = each.value.os_profile.computer_name
    admin_username = each.value.os_profile.admin_username
    admin_password = each.value.os_profile.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = each.value.environment
  }
}
