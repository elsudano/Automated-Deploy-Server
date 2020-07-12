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
variable "vmws_frontend_sourceid" {
  type        = string
  description = "(Required) The ID of the VM that to use for clone at the new"
}
variable "vmws_frontend_denomination1" {
  type        = string
  description = "(Required) The Name of VM in WS "
  default     = "NewInstance"
}
variable "vmws_frontend_description1" {
  type        = string
  description = "(Required) The Description at later maybe to explain the instance  "
}
variable "vmws_frontend_denomination2" {
  type        = string
  description = "(Required) The Name of VM in WS "
  default     = "NewInstance"
}
variable "vmws_frontend_description2" {
  type        = string
  description = "(Required) The Description at later maybe to explain the instance  "
}
# variable "vmws_frontend_image" {
#   type        = string
#   description = "(Required) Which is the name of image for create a VM "
#   default     = "centos-7-x64"
# }
variable "vmws_frontend_processors" {
  type        = string
  description = "(Required) The number of processors that will have a VM "
  default     = 2
}
variable "vmws_frontend_memory" {
  type        = string
  description = "(Required) The size that will have the VM "
  default     = 1024
}