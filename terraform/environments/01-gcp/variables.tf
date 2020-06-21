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
  default     = "mync"
}
variable "google_frontend_name" {
  type        = string
  description = "(Required) The Name of VM in WS "
  default     = "server"
}
variable "google_frontend_machine_type" {
  type        = string
  description = "(Required) The size that will have the VM "
  default     = "f1-micro"
}
variable "google_vpc_name" {
  type        = string
  description = "(Required) The name of VPC for the project"
}
variable "google_firewall_name" {
  type        = string
  description = "(Required) The name of firewall of the VPC to the project"
}