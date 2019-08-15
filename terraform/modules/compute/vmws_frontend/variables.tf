variable "vmws_user" {
  type        = "string"
  description = "(Required) This is a User to use for the API REST of VmWare Workstation Pro."
}
variable "vmws_password" {
  type        = "string"
  description = "(Required) This is a Password to use for the API REST of VmWare Workstation Pro."
}
variable "vmws_url_to_api" {
  type        = "string"
  description = "(Required) This is a URL to connect for the API REST of VmWare Workstation Pro."
}