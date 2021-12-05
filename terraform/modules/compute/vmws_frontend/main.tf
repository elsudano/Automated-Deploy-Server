resource "vmworkstation_vm" "test_machine" {
  sourceid     = var.sourceid # The VM API need this parameter
  denomination = var.denomination
  description  = var.description
  path         = var.path
  processors   = var.processors
  memory       = var.memory
  # image        = var.vmws_reource_frontend_image // maybe in the next version
}
