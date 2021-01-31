terraform {
  required_providers {
    vmworkstation = {
      source  = "elsudano/vmworkstation"
      version = "0.1.8"
    }
  }
  required_version = ">= 0.15"
}

provider "vmworkstation" {
  # Configuration options
}