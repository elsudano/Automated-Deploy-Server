# module "ovh" {
#   source    = "../../providers/ovh"
# }
resource "ovh_domain_zone_record" "subdomain1" {
  zone      = var.ovh_zone
  subdomain = var.ovh_subdomain
  fieldtype = "A"
  ttl       = "3600"
  target    = var.ovh_target
}
