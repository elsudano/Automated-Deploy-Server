provider "vmworkstation" {
  version    = "0.0.1"
  user       = "${var.vmworkstation_user}"
  password   = "${var.vmworkstation_pass}"
  url_to_api = "${var.vmworkstation_url_api}"
}
