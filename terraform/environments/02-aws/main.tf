module "aws_frontend" {
  source                      = "../../modules/compute/aws_frontend"
  ssh_user                    = var.ssh_user
  public_key                  = var.public_key 
  private_key                 = var.private_key
}
module "ovh_domain" {
  source        = "../../modules/networking/ovh_domain"
  ovh_zone      = var.ovh_zone
  ovh_subdomain = var.ovh_subdomain
  ovh_target    = module.aws_frontend.aws_frontend_public_ip
}