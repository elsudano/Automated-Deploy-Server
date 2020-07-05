# This block it's to testing terraform 0.13_beta2
terraform {
  required_version = ">= 0.13"
  required_providers {
    vmworkstation = {
      source  = "elsudano/vmworkstation"
      version = "0.1.0"
    }
    hashicorp = {

    }
  }
}
# This block it's to testing terraform 0.12
# provider "vmworkstation" {
#   version  = "~> 0.1.0"
# }