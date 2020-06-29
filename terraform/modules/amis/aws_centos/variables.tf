variable "centos_version" {
  type        = string
  description = "(Optional) Which is the version of CentOS at install"
  default     = ""
}
variable "centos_ami_creation_day" {
  type        = string
  description = "(Optional) The day to AWS create the AMI"
  default     = ""
}