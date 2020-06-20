# De momento este fichero no sirve por que el modulo
# de terraform de azure no lo lee desde aquí
provider "azurerm" {
  version = "~>2.15.0"
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

