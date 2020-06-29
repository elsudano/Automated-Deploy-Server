output centos_7_id {
  value       = data.aws_ami.centos_7.image_id
  description = "This is a ID of image to CentOS 7"
}
output centos_8_id {
  value       = data.aws_ami.centos_8.image_id
  description = "This is a ID of image to CentOS 8"
}
output centos_custom_id {
  value       = data.aws_ami.centos_custom.image_id
  description = "This is a ID of image to CentOS at you selected with the custom variable"
}