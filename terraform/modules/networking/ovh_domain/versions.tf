terraform {
  required_providers {
    ovh = {
      source = "ovh/ovh"
    }
  }
  required_version = ">= 0.14.5"
}
provider "ovh" {
  endpoint = "ovh-eu"
}
