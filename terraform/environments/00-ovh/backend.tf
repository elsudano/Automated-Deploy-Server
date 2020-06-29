terraform {
  backend "local" {
    path = "./terraform/environments/00-ovh/terraform.tfstate"
  }
}