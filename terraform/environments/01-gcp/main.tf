module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.0"

  name                              = var.google_project_name
  org_id                            = var.google_organisation_id
  credentials_path                  = var.google_credentials_file
  billing_account                   = var.google_billing_account_id
  # folder_id                         = var.google_folder_id
  bucket_name                       = var.google_tfstate_bucket_name
  bucket_project                    = var.google_project_name
  usage_bucket_name                 = var.google_tfstate_bucket_name
  bucket_versioning                 = true
  random_project_id                 = false
  default_service_account           = "delete" # to delete the default service account
  lien                              = var.google_delete_protection # to prevent accidental deletion 
}
module "google_frontend" {
  source = "../../modules/compute/google_frontend"
  ssh_user                       = var.ssh_user
  public_key                     = var.public_key
  private_key                    = var.private_key
  storage_project                = module.project-factory.project_id
  delete_protection              = var.google_delete_protection
  reource_frontend_name          = var.google_frontend_name
  vpc_name                       = var.google_shared_vpc_name
  firewall_name                  = var.google_firewall_name
  reource_frontend_machine_type  = var.google_frontend_machine_type
}
module "ovh_domain" {
  source        = "../../modules/networking/ovh_domain"
  ovh_zone      = var.ovh_zone
  ovh_subdomain = var.ovh_subdomain
  # ovh_target    = module.do_net.public_ip
  ovh_target = module.google_frontend.google_frontend_endpoint
}