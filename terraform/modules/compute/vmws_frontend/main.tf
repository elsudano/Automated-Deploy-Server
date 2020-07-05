# This block it's to testing terraform 0.13_beta2
terraform {
  required_version = ">= 0.13"
  required_providers {
    vmworkstation = {
      source  = "elsudano/vmworkstation"
      version = "0.1.0"
    }
  }
}
# This block it's to testing terraform 0.12
# module "vmws" {
#   source = "../../providers/vmws"
# }
resource "vmworkstation_vms" "test_machine" {
  name       = var.vmws_reource_frontend_name
  image      = var.vmws_reource_frontend_image
  processors = var.vmws_reource_frontend_processors
  memory     = var.vmws_reource_frontend_memory
}
