# output "name_project" {
#     value = "${digitalocean_project.project.name}"
# }
output "google_frontend_endpoint" {
    value = "${module.google_frontend.google_frontend_endpoint}"
}