terraform {
  backend "local" {
    path = "./terraform/environments/02-aws/terraform.tfstate"
  }
}