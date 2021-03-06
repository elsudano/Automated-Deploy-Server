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
variable "do_name_droplet" {
  type        = string
  description = "(Required) The Name of Droplet "
}
variable "do_image_droplet" {
  type        = string
  description = "(Required) The ID (slug) of the image with to create a Droplet"
  default     = "centos-7-x64"
}
variable "do_tags_droplet" {
  type        = list(string)
  description = "(Optional) List of TAGs for identify a droplet"
}
variable "ovh_zone" {
  type        = string
  description = "(Required) Principal domain."
}
variable "ovh_subdomain" {
  type        = string
  description = "(Required) Subdomain created for the instance."
  default     = "donc"
}