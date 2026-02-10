
resource "azurerm_orchestrated_virtual_machine_scale_set" "vmss" {
  name                        = "<VMSS_NAME>"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  sku_name                    = "<VM_SIZE>"                  # e.g., Standard_D2s_v4
  instances                   = <INSTANCE_COUNT>             # e.g., 2 or 3
  platform_fault_domain_count = 1
  zones                       = ["<ZONE_NUMBER>"]            # e.g., "1"

  user_data_base64 = base64encode(file("<USER_DATA_SCRIPT_PATH>"))

  os_profile {
    linux_configuration {
      disable_password_authentication = true

      admin_username = "<ADMIN_USERNAME>"

      admin_ssh_key {
        username   = "<ADMIN_USERNAME>"
        public_key = file("<SSH_PUBLIC_KEY_PATH>")
      }
    }
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-LTS-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name                          = "<NIC_NAME>"
    primary                       = true
    enable_accelerated_networking = false

    ip_configuration {
      name                                   = "<IP_CONFIG_NAME>"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.bepool.id
      ]
    }
  }

  boot_diagnostics {
    storage_account_uri = "<BOOT_DIAGNOSTICS_STORAGE_URI>" # optional
  }

  lifecycle {
    ignore_changes = [
      instances
    ]
  }
}
