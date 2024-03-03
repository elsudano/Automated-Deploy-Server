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
variable "vm_user" {
  type        = string
  description = "(Required) Username that will be used to authenticate in the API REST of VmWare Workstation."
}
variable "vm_password" {
  type        = string
  description = "(Required) Matcnhing password for the user to authenticate in the API REST of VmWare Workstation."
}
variable "vm_url" {
  type        = string
  description = "(Required) This is the URL where the API REST of VmWare Workstation are listen, normally in https://localhost:8697/api."
}
variable "list_of_vms" {
  type = map(object({
    sourceid    = string
    description = string
    path        = string
    processors  = string
    memory      = string
    state       = string
  }))
  description = "You can put inside this variable all the data you need in order to create a differents vms in VmWare Workstation."
  default = {
    "key" = {
      sourceid    = null
      description = null
      path        = null
      processors  = "1"
      memory      = "512"
      state       = "off"
    }
  }
}
