terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.44.0"
    }
  }
  required_version = ">= 0.14.5"
}

provider "azurerm" {
  features {
    key_vault {
      recover_soft_deleted_key_vaults = true
      purge_soft_delete_on_destroy    = true
    }
    virtual_machine {
      delete_os_disk_on_deletion = true
    }
    virtual_machine_scale_set {
      roll_instances_when_required = true
    }
  }
}
