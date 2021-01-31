# module "azurerm" {
#   source = "../../providers/azure"
# }
resource "azurerm_linux_virtual_machine" "azure_frontend" {
  name                = var.arm_name_instance
  resource_group_name = var.arm_resource_group_name
  location            = var.arm_resource_group_location
  size                = var.arm_size_instance
  admin_username      = var.ssh_user
  network_interface_ids = [
    var.arm_nic_id,
  ]

  admin_ssh_key {
    username   = var.ssh_user
    public_key = file(var.public_key)
  }

  os_disk {
    caching              = var.arm_config_os_disk[0]
    storage_account_type = var.arm_config_os_disk[1]
  }

  source_image_reference {
    publisher = var.arm_config_image[0]
    offer     = var.arm_config_image[1]
    sku       = var.arm_config_image[2]
    version   = var.arm_config_image[3]
  }
}
