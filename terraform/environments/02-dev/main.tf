# module "do_frontend" {
#   source           = "../../modules/compute/do_frontend"
#   do_name_droplet  = "${var.do_name_droplet}"
#   do_image_droplet = "${var.do_image_droplet}"
#   do_tags_droplet  = "${var.do_tags_droplet}"
#   public_key    = "${var.public_key}"
#   private_key   = "${var.private_key}"
# }
module "google_frontend" {
  source = "../../modules/compute/google_frontend"

  ssh_user                             = "${var.ssh_user}"
  public_key                           = "${var.public_key}"
  private_key                          = "${var.private_key}"
  google_reource_frontend_name         = "${var.google_frontend_name}"
  google_vpc_name                      = "${var.google_vpc_name}"
  google_firewall_name                 = "${var.google_firewall_name}"
  google_reource_frontend_machine_type = "${var.google_frontend_machine_type}"
}
# module "vmws_frontend" {
#   source = "../../modules/compute/vmws_frontend"
#   vmws_reource_frontend_name        = "${var.vmws_frontend_name}"
#   vmws_reource_frontend_image       = "${var.vmws_frontend_image}"
#   vmws_reource_frontend_processors  = "${var.vmws_frontend_processors}"
#   vmws_reource_frontend_memory      = "${var.vmws_frontend_memory}"
# }
# module "do_net" {
#   source        = "../../modules/networking/do_net"
#   do_droplet_id = "${module.do_frontend.first_droplet_id}"
# }
# module "ovh_domain" {
#   source        = "../../modules/networking/ovh_domain"
#   ovh_zone      = "${var.ovh_zone}"
#   ovh_subdomain = "${var.ovh_subdomain}"
#   ovh_target    = "${module.do_net.public_ip}"
# }
# resource "digitalocean_project" "project" {
#   name        = "NextCloud"
#   description = "Test for deployment personal server with all resources for work remotly"
#   purpose     = "Web Application"
#   environment = "Development"
#   resources   = ["${module.do_frontend.first_droplet_urn}", "${module.do_net.public_ip_urn}"]
# }
