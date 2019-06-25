output "ssh_key_id" {
  value       = "${digitalocean_ssh_key.default.id}"
  description = "The ID of the SSH Key create for connect remotely"
}