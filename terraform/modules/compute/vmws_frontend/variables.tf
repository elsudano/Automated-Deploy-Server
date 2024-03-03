variable "sourceid" {
  type        = string
  description = "(Required) The ID of the VM that to use for clone at the new"
}
variable "denomination" {
  type        = string
  description = "(Required) The Name of VM in WS "
  default     = "NewInstance"
}
variable "description" {
  type        = string
  description = "(Required) The Description at later maybe to explain the instance "
}
variable "path" {
  type        = string
  description = "(Required) The path where the instance is deployed "
  default = "D:\\VirtualMachines"
}
# variable "image" {
#   type        = string
#   description = "(Required) The ID of the Image with to create a Virtual Machine"
#   default     = "CentOS x64"
# }
variable "processors" {
  type        = string
  description = "(Required) The number of processors of the Virtual Machine"
  default     = "1"
}
variable "memory" {
  type        = string
  description = "(Required) The size of memory to the Virtual Machine"
  default     = "512"
}
variable "state" {
  type        = string
  description = "(Optional) The Power State desired in the Virtual Machine"
  default     = "off"
}  