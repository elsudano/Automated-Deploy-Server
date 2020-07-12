module "vmws_frontend1" {
  source = "../../modules/compute/vmws_frontend"
  vmws_reource_frontend_sourceid      = var.vmws_frontend_sourceid # esto lo tenemos que poner por que lo exige la api
  vmws_reource_frontend_denomination  = var.vmws_frontend_denomination1
  vmws_reource_frontend_description   = var.vmws_frontend_description1
  # vmws_reource_frontend_image        = var.vmws_frontend_image
  vmws_reource_frontend_processors    = var.vmws_frontend_processors
  vmws_reource_frontend_memory        = var.vmws_frontend_memory
}

module "vmws_frontend2" {
  source = "../../modules/compute/vmws_frontend"
  vmws_reource_frontend_sourceid      = module.vmws_frontend1.vmws_frontend_id # esto lo tenemos que poner por que lo exige la api
  vmws_reource_frontend_denomination  = var.vmws_frontend_denomination2
  vmws_reource_frontend_description   = var.vmws_frontend_description2
  # vmws_reource_frontend_image        = var.vmws_frontend_image
  vmws_reource_frontend_processors    = var.vmws_frontend_processors
  vmws_reource_frontend_memory        = var.vmws_frontend_memory
}