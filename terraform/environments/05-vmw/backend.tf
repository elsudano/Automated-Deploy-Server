terraform {
  backend "local" {
    path          = "./terraform.tfstate"
    workspace_dir = "."
  }
}