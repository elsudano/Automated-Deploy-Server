output "arm_nic_id" {
  value       = azurerm_network_interface.azure_nic.id
  description = "This is the ID of the nic to the instance"
}
output "arm_public_ip" {
  value       = azurerm_public_ip.azure_pip.ip_address
  description = "This is public IP to the instance"
}