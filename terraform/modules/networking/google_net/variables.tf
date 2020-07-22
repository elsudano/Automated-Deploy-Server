variable "storage_project" {
  type        = string
  description = "(Required) The name of the project where are create the VPC and firewall"
}
variable "vpc_name" {
  type        = string
  description = "(Required) The name of VPC for the project"
}
variable "firewall_name" {
  type        = string
  description = "(Required) The name of firewall of the VPC to the project"
}
