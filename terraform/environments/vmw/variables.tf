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
variable "list_of_vms" {
  type = map(object({
    sourceid     = string
    denomination = string
    description  = string
    path         = string
    processors   = string
    memory       = string
  }))
  description = "You can put inside this variable all the data you need in order to create a differents vms in VmWare Workstation."
  default = {
    "key" = {
      sourceid     = null
      denomination = null
      description  = null
      path         = null
      processors   = "1"
      memory       = "512"
    }
  }
}