# module "azure" {
#   source = "../../providers/azure"
# }
resource "azurerm_virtual_network" "azure_vpc" {
  name                = var.arm_vpc_name
  address_space       = var.arm_cidr_vpc_network
  resource_group_name = var.arm_resource_group_name
  location            = var.arm_resource_group_location
}
resource "azurerm_subnet" "azure_subnet" {
  name                 = var.arm_subnet_name
  resource_group_name  = var.arm_resource_group_name
  virtual_network_name = azurerm_virtual_network.azure_vpc.name
  address_prefixes     = var.arm_cidr_subnet_network
}
resource "azurerm_public_ip" "azure_pip" {
  name                = var.arm_pip_name
  resource_group_name = var.arm_resource_group_name
  location            = var.arm_resource_group_location
  allocation_method   = "Dynamic"
}
resource "azurerm_network_interface" "azure_nic" {
  name                = var.arm_nic_name
  resource_group_name = var.arm_resource_group_name
  location            = var.arm_resource_group_location

  ip_configuration {
    name                          = var.arm_nic_name
    subnet_id                     = azurerm_subnet.azure_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.azure_pip.id
  }
}