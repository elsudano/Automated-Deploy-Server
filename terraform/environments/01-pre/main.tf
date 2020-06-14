terraform {
  backend "local" {
    path = "terraform/environments/01-pre/terraform.tfstate"
  }
}
module "google_frontend" {
  source = "../../modules/compute/google_frontend"
  ssh_user                             = var.ssh_user
  public_key                           = var.public_key
  private_key                          = var.private_key
  google_reource_frontend_name         = var.google_frontend_name
  google_vpc_name                      = var.google_vpc_name
  google_firewall_name                 = var.google_firewall_name
  google_reource_frontend_machine_type = var.google_frontend_machine_type
}
module "ovh_domain" {
  source        = "../../modules/networking/ovh_domain"
  ovh_zone      = var.ovh_zone
  ovh_subdomain = var.ovh_subdomain
  # ovh_target    = module.do_net.public_ip
  ovh_target = module.google_frontend.google_frontend_endpoint
}