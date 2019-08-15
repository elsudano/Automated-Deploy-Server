module "vmworkstation" {
  source          = "../../providers/vmworkstation"
  vmws_user       = "${var.vmws_user}"
  vmws_password   = "${var.vmws_password}"
  vmws_url_to_api = "${var.vmws_url_to_api}"
}