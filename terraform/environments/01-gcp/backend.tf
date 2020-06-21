terraform {
  backend "local" {
    path = "./terraform/environments/01-gcp/terraform.tfstate"
  }
}