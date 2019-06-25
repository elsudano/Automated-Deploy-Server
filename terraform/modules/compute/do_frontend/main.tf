resource "digitalocean_droplet" "do_droplet_small" {
    name  = "${var.do_name_droplet}"
    image = "${var.do_image_droplet}"
    region = "lon1"
    size   = "s-1vcpu-1gb"
    backups = false
    monitoring = false
    ipv6 = false
    private_networking = true
    ssh_keys = ["${var.do_ssh_key_droplet}"]
    resize_disk = false
    tags = "${var.do_tags_droplet}"
}