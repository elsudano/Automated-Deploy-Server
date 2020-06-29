# output "aws_gateway" {
#   value       = aws_internet_gateway.aws_gateway
#   description = "The object of Gateway in the VPC of project"
# }
output "aws_subnet_id" {
  value       = aws_subnet.aws_subnet.id
  description = "The ID of a subnet"
}
output "aws_public_ip" {
  value       = aws_eip.aws_eip.public_ip
  description = "The public IP in the VPC"
}
output "aws_security_group_id" {
  value       = aws_default_security_group.default.id
  description = "The Id of security group of the VPC"
}