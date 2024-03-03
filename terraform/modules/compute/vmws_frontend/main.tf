resource "vmworkstation_vm" "vm" {
  sourceid     = var.sourceid # The VM API need this parameter
  denomination = var.denomination
  description  = var.description
  path         = var.path
  processors   = var.processors
  memory       = var.memory
  state        = var.state
  # image        = var.vmws_reource_frontend_image // maybe in the next version
}
