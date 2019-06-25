module "do" {
	source     = "../../modules/providers/do"
	do_token   = "${var.do_token}"
	do_ssh_key = "${var.do_ssh_key}"
}

module "do_frontend" {
	source             = "../../modules/compute/do_frontend"
	do_name_droplet    = "${var.do_name_droplet}"
	do_image_droplet   = "${var.do_image_droplet}"
	do_tags_droplet    = "${var.do_tags_droplet}"
	do_ssh_key_droplet = "${module.do.ssh_key_id}"
}
module "do_net" {
	source             = "../../modules/networking/do_net"
	do_droplet_id_net    = "${module.do_frontend.droplet_id}"
}
resource "digitalocean_project" "project" {
	name        = "NextCloud"
	description = "Test for deployment personal server with all resources for work remotly"
	purpose     = "Web Application"
	environment = "Development"
	resources   = ["${module.do_frontend.droplet_urn}","${module.do_net.public_ip_urn}"]
}