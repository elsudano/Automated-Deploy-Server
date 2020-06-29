variable "ubuntu_version" {
  type        = string
  description = "(Optional) Which is the version of OS Ubuntu at install"
  default     = ""
}
variable "ubuntu_ami_creation_day" {
  type        = string
  description = "(Optional) The day to AWS create the AMI"
  default     = ""
}