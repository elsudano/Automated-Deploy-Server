output "google_frontend_endpoint" {
  value       = module.google_frontend.google_frontend_endpoint
  sensitive   = false
  description = "The IP of the instance created"
}
output "google_project_service_account_json" {
  value       = module.project-factory.service_account_email
  sensitive   = true
  description = "The Service Account of the Project that's created"
}
output "ovh_subdomain" {
  value       = module.ovh_domain.subdomain
  sensitive   = false
  description = "The subdomain that's created"
}