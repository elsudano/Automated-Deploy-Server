module "google" {
  source = "../../providers/google"
}
resource "google_compute_network" "vpc" {
  project                 = var.storage_project
  name                    = var.vpc_name
  auto_create_subnetworks = "true"
}
resource "google_compute_firewall" "firewall" {
  project = var.storage_project
  name    = var.firewall_name
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22","80","443","3306", "10000"]
  }

  source_ranges = ["0.0.0.0/0"]
  source_tags  = ["access-from-internet"]
}
