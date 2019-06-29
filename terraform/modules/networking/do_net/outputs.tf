output public_ip_urn {
  value       = "${digitalocean_floating_ip.public_ip.urn}"
  description = "This is public IP that no change for entry to droplet"
}
output public_ip {
  value       = "${digitalocean_floating_ip.public_ip.ip_address}"
  description = "This is public IP that no change for entry to droplet"
}