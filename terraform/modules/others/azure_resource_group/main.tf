module "azurerm" {
  source = "../../providers/azure"
}
resource "azurerm_resource_group" "azure_resource_group" {
  name     = var.arm_resource_group_name
  location = var.arm_resource_group_location
}