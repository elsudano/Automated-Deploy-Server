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
variable "ovh_zone" {
  type        = string
  description = "(Required) Principal domain."
}
variable "ovh_subdomain" {
  type        = string
  description = "(Required) Subdomain created for the instance."
  default     = "mync"
}
variable "google_organisation_id" {
  type        = string
  description = "(Required) The ID of the Organisation in GCP where are create the projects "
}
variable "google_billing_account_id" {
  type        = string
  description = "(Required) The ID of the Billing Account in GCP to the project "
}
variable "google_credentials_file" {
  type        = string
  description = "(Required) The file with the service account with permissions "
}
variable "google_project_name" {
  type        = string
  description = "(Required) Name of the project in GCP "
  default     = "first"
}
variable "google_enable_api_list" {
  type        = list(string)
  description = "(Required) List of APIs to be activated in the project"
}
variable "google_tfstate_bucket_name" {
  type        = string
  description = "(Required) Name of the Bucket to storage the tfstate files for the project "
}
variable "google_tfstate_prefix" {
  type        = string
  description = "(Required) Prefix to create folders in the bucket to organize the tfstate files "
  default     = "environments/pro"
}
variable "google_shared_vpc_name" {
  type        = string
  description = "(Required) Name of the Shared VPC that connect with another projects "
}
variable "google_folder_id" {
  type        = string
  description = "(Required) Denomination of the parent folder where is the project "
}
variable "google_group_admin_name" {
  type        = string
  description = "(Required) A group to control the project by being assigned group_role "
}
variable "google_group_admin_role" {
  type        = string
  description = "(Required) The role to give the controlling group (group_name) over the project (defaults to project editor) "
  default     = "roles/editor"
}
variable "google_delete_protection" {
  type        = bool
  description = "(Optional) To prevent the accidental deletion "
  default     = false
}
variable "google_frontend_name" {
  type        = string
  description = "(Required) The Name of VM in WS "
  default     = "server"
}
variable "google_frontend_machine_type" {
  type        = string
  description = "(Required) The size that will have the VM "
  default     = "f1-micro"
}
variable "google_firewall_name" {
  type        = string
  description = "(Required) The name of firewall of the VPC to the project"
}