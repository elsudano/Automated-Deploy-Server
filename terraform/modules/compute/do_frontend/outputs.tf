output droplet_id {
  value       = "${digitalocean_droplet.do_droplet_small.id}"
  description = "This is a ID of droplet for assign to the another resource"
}
output "droplet_urn" {
  value       = "${digitalocean_droplet.do_droplet_small.urn}"
  description = "URL for entry remotely in the droplet"
}