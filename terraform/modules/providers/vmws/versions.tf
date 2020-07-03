terraform {
  required_version = ">= 0.13"
  required_providers {
    hashicorp = {

    }
    vmworkstation = {
      source  = "terraform-providers/vmworkstation"
      version = "0.1.0"
    }
  }
}