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
variable "ovh_zone" {
  type        = string
  description = "(Required) Principal domain."
}
variable "ovh_subdomain" {
  type        = string
  description = "(Required) Subdomain created for the instance."
}