output aws_frontend_id {
  value       = aws_instance.aws_frontend.id
  description = "This is a ID of aws instance for assign to the another resource"
}
output aws_frontend_public_ip {
  value       = aws_instance.aws_frontend.public_ip
  description = "The public IP of the instance"
}