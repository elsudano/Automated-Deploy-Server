terraform {
  backend "local" {
    path = "./terraform/environments/05-vmw/terraform.tfstate"
  }
}