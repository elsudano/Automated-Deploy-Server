terraform {
  backend "local" {
    path = "./terraform/environments/04-do/terraform.tfstate"
  }
}