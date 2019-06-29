provider "ovh" {
  version            = "0.5"
  application_key    = "${var.ovh_application_key}"
  application_secret = "${var.ovh_application_secret}"
  consumer_key       = "${var.ovh_consumer_key}"
}
