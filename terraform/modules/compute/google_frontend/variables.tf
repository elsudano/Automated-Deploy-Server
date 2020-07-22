variable "ssh_user" {
  type        = string
  description = "(Required) The default user for connect remotely to instance"
  default     = "centos"
}
variable "public_key" {
  type        = string
  description = "(Required) The file with the public key for connect to instance"
}
variable "private_key" {
  type        = string
  description = "(Required) Path the file of Private KEY for accessing to instance"
}
variable "reource_frontend_name" {
  type        = string
  description = "(Required) The Name of VM"
}
variable "reource_frontend_machine_type" {
  type        = string
  description = "(Optional) The ID of the machine_type with to create a Virtual Machine"
  default     = "f1-micro"
}
variable "vpc_name" {
  type        = string
  description = "(Required) The name of VPC for the project"
}
variable "firewall_name" {
  type        = string
  description = "(Required) The name of firewall of the VPC to the project"
}
variable "delete_protection" {
  type        = bool
  description = "(Optional) Put delete protection at the instance"
  default     = false
}
variable "storage_project" {
  type        = string
  description = "(Required) The ID or the project from storage the instance"
}

# variable "reource_frontend_processors" {
#   type        = string
#   description = "(Required) The number of processors of the Virtual Machine"
#   default     = "1"
# }
# variable "reource_frontend_memory" {
#   type        = string
#   description = "(Required) The size of memory to the Virtual Machine"
#   default     = "512"
# }
   
