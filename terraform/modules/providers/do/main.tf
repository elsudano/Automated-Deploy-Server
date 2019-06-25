provider "digitalocean" {
    token = "${var.do_token}"
    # Optionals
    #spaces_access_id = var.do_spaces_access_id
    #spaces_secret_key = var.do_spaces_secret_key
    #api_endpoint = var.do_api_endpoint
}
resource "digitalocean_ssh_key" "default" {
  name       = "SSH Key"
  public_key = "${var.do_ssh_key}"
}