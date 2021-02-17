# module "ovh_frontend" {
#   source           = "../../modules/compute/ovh_frontend"
#   ovh_name_vps  = var.ovh_name_vps
#   ovh_image_vps = var.ovh_image_vps
#   public_key    = var.public_key
#   private_key   = var.private_key
# }
# module "ovh_domain" {
#   source        = "../../modules/networking/ovh_domain"
#   ovh_zone      = var.ovh_zone
#   ovh_subdomain = var.ovh_subdomain
#   ovh_target    = module.ovh_frontend.my_vps_ip
# }
