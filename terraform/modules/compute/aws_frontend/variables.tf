variable "ssh_user" {
  type        = string
  description = "(Required) The default user for connect remotely to instance"
  default     = "centos"
}
variable "public_key" {
  type        = string
  description = "(Required) Containt the Public KEY access to remote instance"
}
variable "private_key" {
  type        = string
  description = "(Optional) Path the file of Private KEY for accessing to instance"
}
variable "arm_resource_group_name" {
  type        = string
  description = "(Required) The name of Resource Group"
}
variable "arm_resource_group_location" {
  type        = string
  description = "(Required) The location of Resource Group"
}
variable "arm_nic_id" {
  type        = string
  description = "(Required) This is the ID of the nic to the instance"
}
variable "arm_name_instance" {
  type        = string
  description = "(Required) The Name of instance "
}
variable "arm_size_instance" {
  type        = string
  description = "(Required) The Size of instance "
  default     = "Standard_A1_v2"
}
variable "arm_config_os_disk" {
  type        = list(string)
  description = "(Required) Array with the config of os disk in format [\"caching\", \"storage_account_type\"]"
  default     = ["ReadWrite", "Standard_LRS"]
}
variable "arm_config_image" {
  type        = list(string)
  description = "(Required) Array with the config of image in format [\"publisher\", \"offer\", \"sku\", \"version\"]"
  default     = ["Canonical", "UbuntuServer", "16.04-LTS", "latest"]
}