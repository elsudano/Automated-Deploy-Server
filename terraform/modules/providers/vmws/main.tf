# This block it's to testing terraform 0.13_beta2
terraform {
  required_version = ">= 0.13"
  required_providers {
    vmworkstation = {
      source  = "elsudano/vmworkstation"
      version = "0.1.0"
    }
    hashicorp = {
      # TF-UPGRADE-TODO
      #
      # No source detected for this provider. You must add a source address
      # in the following format:
      #
      # source = "your-registry.example.com/organization/hashicorp"
      #
      # For more information, see the provider source documentation:
      #
      # https://www.terraform.io/docs/configuration/providers.html#provider-source

    }
  }
}
# This block it's to testing terraform 0.12
# provider "vmworkstation" {
#   version  = "~> 0.1.0"
# }