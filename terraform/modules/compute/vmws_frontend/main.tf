terraform {
  required_providers {
    vmworkstation = {
      source  = "elsudano/vmworkstation"
      version = "0.1.9"
    }
  }
  required_version = ">= 0.14.5"
}
resource "vmworkstation_vm" "test_machine" {
  sourceid     = var.vmws_reource_frontend_sourceid # The VM API need this parameter
  denomination = var.vmws_reource_frontend_denomination
  description  = var.vmws_reource_frontend_description
  # image        = var.vmws_reource_frontend_image // maybe in the next version
  processors   = var.vmws_reource_frontend_processors
  memory       = var.vmws_reource_frontend_memory
}
