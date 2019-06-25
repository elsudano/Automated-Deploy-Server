variable "do_token" {
  type        = "string"
  description = "(Required) This is the DO API token. "
}
variable "do_ssh_key" {
  type        = "string"
  description = "(Optional) Path of file that contains public part of key"
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