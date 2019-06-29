variable "ovh_application_key" {
  type        = "string"
  description = "(Required) This is the OVH API token."
}
variable "ovh_application_secret" {
  type        = "string"
  description = "(Required) Secret of the application key"
}
variable "ovh_consumer_key" {
  type        = "string"
  description = "(Required) This is a consumer key of the OVH platform"
}
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