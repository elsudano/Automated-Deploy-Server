module "do" {
  source        = "../../providers/do"
  do_token      = "${var.do_token}"
}
resource "digitalocean_floating_ip" "public_ip" {
  region            = "lon1"
}
resource "digitalocean_floating_ip_assignment" "assign_ip" {
  ip_address = "${digitalocean_floating_ip.public_ip.id}"
  droplet_id = "${var.do_droplet_id}"
}