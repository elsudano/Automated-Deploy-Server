output "arm_nic_id" {
  value       = azurerm_network_interface.azure_nic.id
  description = "This is the ID of the nic to the instance"
}