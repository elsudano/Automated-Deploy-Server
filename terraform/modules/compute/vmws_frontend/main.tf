module "vmws" {
  source          = "../../providers/vmws"
}
resource "vmworkstation_vms" "list_vms" {
  name  = "list_vms"
}
