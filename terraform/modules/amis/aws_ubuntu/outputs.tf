output ubuntu_1404_id {
  value       = data.aws_ami.ubuntu_1404.image_id
  description = "This is a ID of image to Ubuntu 14.04"
}
output ubuntu_1804_id {
  value       = data.aws_ami.ubuntu_1804.image_id
  description = "This is a ID of image to Ubuntu 18.04"
}
output ubuntu_custom_id {
  value       = data.aws_ami.ubuntu_custom.image_id
  description = "This is a ID of image to Ubuntu at you selected with the custom variable"
}