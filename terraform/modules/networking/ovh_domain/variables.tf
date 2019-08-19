variable "ovh_zone" {
  type        = "string"
  description = "(Required) Principal domain."
}
variable "ovh_subdomain" {
  type        = "string"
  description = "(Required) Subdomain created for the instance."
}
variable "ovh_target" {
  type        = "string"
  description = "(Required) This is a IP to where send communication of the subdomain."
}