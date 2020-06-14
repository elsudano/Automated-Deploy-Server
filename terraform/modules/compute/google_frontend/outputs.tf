output "google_frontend_endpoint" {
  value       = google_compute_instance.google_frontend.network_interface[0].access_config[0].nat_ip
  description = "IP of the endpoit of server"
}