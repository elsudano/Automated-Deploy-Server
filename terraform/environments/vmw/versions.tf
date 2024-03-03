terraform {
  required_providers {
    vmworkstation = {
      source  = "elsudano/vmworkstation"
      version = "~>1.0.4"
    }
  }
  required_version = ">= 1.0.0"
}

provider "vmworkstation" {
  user     = var.vm_user
  password = var.vm_password
  url      = var.vm_url
}
