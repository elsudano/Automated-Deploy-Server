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
# variable "ubuntu_version" {
#   type        = string
#   description = "(Optional) Which is the version of OS Ubuntu at install"
#   default     = "18.04"
# }
# variable "ubuntu_ami_creation_day" {
#   type        = string
#   description = "(Optional) The day to AWS create the AMI"
# }