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
  description = "(Required) Path the file of Private KEY for accessing to instance"
}
variable "ovh_name_vps" {
  type        = string
  description = "(Required) The Name of VPS"
}
variable "ovh_image_vps" {
  type        = string
  description = "(Required) The ID of the image with to create a VPS"
  default     = "centos-7-x64"
}
variable "ovh_zone" {
  type        = string
  description = "(Required) Principal domain."
}
variable "ovh_subdomain" {
  type        = string
  description = "(Required) Subdomain created for the instance."
  default     = "nc"
}