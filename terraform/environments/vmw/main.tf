module "vmws_frontend" {
  source       = "../../modules/compute/vmws_frontend"
  for_each     = var.list_of_vms
  sourceid     = each.value.sourceid # esto lo tenemos que poner por que lo exige la api
  denomination = each.key
  description  = each.value.description
  path         = each.value.path
  processors   = each.value.processors
  memory       = each.value.memory
  state        = each.value.state
}
