variable "arm_vpc_name" {
  type        = string
  description = "(Required) The name of VPC for the project"
}
variable "arm_cidr_vpc_network" {
  type        = list(string)
  description = "(Required) The address of network for the VPC format: [\"10.10.10.0/24\",]"
}
variable "arm_subnet_name" {
  type        = string
  description = "(Required) The name of the nic in the instance"
}
variable "arm_cidr_subnet_network" {
  type        = list(string)
  description = "(Required) The addresses of subnet network format: [\"10.10.10.0/24\",]"
}
variable "arm_nic_name" {
  type        = string
  description = "(Required) The name of the nic in the instance"
}
variable "arm_resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group where storage the network"
}
variable "arm_resource_group_location" {
  type        = string
  description = "(Required) The location of the Resource Group where storage the network"
}
