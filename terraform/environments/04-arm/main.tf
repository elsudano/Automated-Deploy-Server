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
module "azure_resource_group" {
  source                      = "../../modules/others/azure_resource_group"
  arm_resource_group_name     = var.arm_resource_group_name
  arm_resource_group_location = var.arm_resource_group_location
}
module "azure_net" {
  source                      = "../../modules/networking/azure_net"
  arm_vpc_name                = var.arm_vpc_name
  arm_cidr_vpc_network        = var.arm_cidr_vpc_network
  arm_subnet_name             = var.arm_subnet_name
  arm_cidr_subnet_network     = var.arm_cidr_subnet_network
  arm_nic_name                = var.arm_nic_name
  arm_resource_group_name     = module.azure_resource_group.arm_resource_group_name
  arm_resource_group_location = module.azure_resource_group.arm_resource_group_location
}
module "azure_frontend" {
  source                      = "../../modules/compute/azure_frontend"
  ssh_user                    = var.ssh_user
  public_key                  = var.public_key 
  private_key                 = var.private_key
  arm_name_instance           = var.arm_name_instance 
  arm_size_instance           = var.arm_size_instance 
  arm_config_os_disk          = var.arm_config_os_disk 
  arm_config_image            = var.arm_config_image
  arm_nic_id                  = module.azure_net.arm_nic_id
  arm_resource_group_name     = module.azure_resource_group.arm_resource_group_name
  arm_resource_group_location = module.azure_resource_group.arm_resource_group_location
}
# module "ovh_domain" {
#   source        = "../../modules/networking/ovh_domain"
#   ovh_zone      = var.ovh_zone
#   ovh_subdomain = var.ovh_subdomain
#   ovh_target    = module.do_net.public_ip
# }