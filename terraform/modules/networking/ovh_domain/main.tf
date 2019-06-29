module "ovh" {
  source                 = "../../providers/ovh"
  ovh_application_key    = "${var.ovh_application_key}"
  ovh_application_secret = "${var.ovh_application_secret}"
  ovh_consumer_key       = "${var.ovh_consumer_key}"
}
resource "ovh_domain_zone_record" "subdomain1" {
  zone      = "${var.ovh_zone}"
  subdomain = "${var.ovh_subdomain}"
  fieldtype = "A"
  ttl       = "3600"
  target    = "${var.ovh_target}"
}
