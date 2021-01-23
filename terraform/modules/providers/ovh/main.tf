terraform {
  required_providers {
    ovh = {
      source = "ovh/ovh"
      version = "0.10.0"
    }
  }
}

provider "ovh" {
  endpoint = "ovh-eu"
}
