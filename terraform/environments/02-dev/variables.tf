variable "ssh_user" {
  type        = "string"
  description = "(Required) The default user for connect remotely to instance"
  default     = "centos"
}
variable "public_key" {
  type        = "string"
  description = "(Required) Containt the Public KEY access to remote instance"
}
variable "private_key" {
  type        = "string"
  description = "(Required) Path the file of Private KEY for accessing to instance"
}
variable "do_name_droplet" {
  type        = "string"
  description = "(Required) The Name of Droplet "
}
variable "do_image_droplet" {
  type        = "string"
  description = "(Required) The ID (slug) of the image with to create a Droplet"
  default     = "centos-7-x64"
}
variable "do_tags_droplet" {
  type        = "list"
  description = "(Optional) List of TAGs for identify a droplet"
}
variable "ovh_zone" {
  type        = "string"
  description = "(Required) Principal domain."
}
variable "ovh_subdomain" {
  type        = "string"
  description = "(Required) Subdomain created for the instance."
}
variable "vmws_frontend_name" {
  type        = "string"
  description = "(Required) The Name of VM in WS "
  default     = "server"
}
variable "vmws_frontend_image" {
  type        = "string"
  description = "(Required) Which is the name of image for create a VM "
  default     = "centos-7-x64"
}
variable "vmws_frontend_processors" {
  type        = "string"
  description = "(Required) The number of processors that will have a VM "
  default     = 2
}
variable "vmws_frontend_memory" {
  type        = "string"
  description = "(Required) The size that will have the VM "
  default     = 1024
}
variable "google_frontend_name" {
  type        = "string"
  description = "(Required) The Name of VM in WS "
  default     = "server"
}
variable "google_frontend_machine_type" {
  type        = "string"
  description = "(Required) The size that will have the VM "
  default     = "f1-micro"
}
variable "google_vpc_name" {
  type        = "string"
  description = "(Required) The name of VPC for the project"
}
variable "google_firewall_name" {
  type        = "string"
  description = "(Required) The name of firewall of the VPC to the project"
}