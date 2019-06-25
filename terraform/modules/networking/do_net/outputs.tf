output public_ip_urn {
  value       = "${digitalocean_floating_ip.public_ip.urn}"
  description = "This is public IP that no change for entry to droplet"
}