module "google" {
  source = "../../providers/google"
}
resource "google_compute_network" "fpc_vpc" {
  name                    = "${var.google_vpc_name}"
  auto_create_subnetworks = "true"
}
resource "google_compute_firewall" "fpc_firewall" {
  name    = "${var.google_firewall_name}"
  network = "${google_compute_network.fpc_vpc.name}"

  allow {
    protocol = "tcp"
    ports    = ["22","80","443"]
  }

  source_ranges = ["0.0.0.0/0"]
  source_tags  = ["access-from-internet"]
}
