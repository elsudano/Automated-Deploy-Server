terraform {
  backend "local" {
    path = "./terraform/environments/03-arm/terraform.tfstate"
  }
}