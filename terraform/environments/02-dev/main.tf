
module "do_frontend" {
  source           = "../../modules/compute/do_frontend"
  do_token         = "${var.do_token}"
  do_name_droplet  = "${var.do_name_droplet}"
  do_image_droplet = "${var.do_image_droplet}"
  do_tags_droplet  = "${var.do_tags_droplet}"
  do_public_key    = "${var.do_public_key}"
  do_private_key   = "${var.do_private_key}"
}
module "do_net" {
  source        = "../../modules/networking/do_net"
  do_token      = "${var.do_token}"
  do_droplet_id = "${module.do_frontend.first_droplet_id}"
}
module "ovh_domain" {
  source                 = "../../modules/networking/ovh_domain"
  ovh_application_key    = "${var.ovh_application_key}"
  ovh_application_secret = "${var.ovh_application_secret}"
  ovh_consumer_key       = "${var.ovh_consumer_key}"
  ovh_zone               = "${var.ovh_zone}"
  ovh_subdomain          = "${var.ovh_subdomain}"
  ovh_target             = "${module.do_net.public_ip}"
}
resource "digitalocean_project" "project" {
  name        = "NextCloud"
  description = "Test for deployment personal server with all resources for work remotly"
  purpose     = "Web Application"
  environment = "Development"
  resources   = ["${module.do_frontend.first_droplet_urn}", "${module.do_net.public_ip_urn}"]
}
