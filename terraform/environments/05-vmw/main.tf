module "vmws_frontend" {
  source = "../../modules/compute/vmws_frontend"
  vmws_reource_frontend_name        = var.vmws_frontend_name
  vmws_reource_frontend_image       = var.vmws_frontend_image
  vmws_reource_frontend_processors  = var.vmws_frontend_processors
  vmws_reource_frontend_memory      = var.vmws_frontend_memory
}

