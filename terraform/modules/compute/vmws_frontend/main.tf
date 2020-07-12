# This block it's to testing terraform 0.13_beta2
terraform {
  required_version = ">= 0.13"
  required_providers {
    vmworkstation = {
      source  = "elsudano/vmworkstation"
      version = "0.1.7"
    }
  }
}
# This block it's to testing terraform 0.12
# module "vmws" {
#   source = "../../providers/vmws"
# }
resource "vmworkstation_vm" "test_machine" {
  sourceid     = var.vmws_reource_frontend_sourceid # The VM API need this parameter
  denomination = var.vmws_reource_frontend_denomination
  description  = var.vmws_reource_frontend_description
  # image        = var.vmws_reource_frontend_image // maybe in the next version
  processors   = var.vmws_reource_frontend_processors
  memory       = var.vmws_reource_frontend_memory
}
