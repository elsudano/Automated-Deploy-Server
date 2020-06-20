output "arm_resource_group_name" {
  value       = azurerm_resource_group.azure_resource_group.name
  description = "This is the name of Resource Group"
}
output "arm_resource_group_location" {
  value       = azurerm_resource_group.azure_resource_group.location
  description = "This is the physical location of resources within of Resource Group"
}