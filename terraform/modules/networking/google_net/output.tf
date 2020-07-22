output vpc_link {
  value       = google_compute_network.vpc.self_link
  description = "This is a link of the VPC of project"
}