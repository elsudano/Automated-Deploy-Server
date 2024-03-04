output "vm_id" {
  value       = tomap({ for key, value in module.vmws_frontend : key => value.vm_id })
  description = "The ID of the VM"
}
output "vm_ip" {
  value       = tomap({ for key, value in module.vmws_frontend : key => value.vm_ip })
  description = "The IP value of the VM"
}
