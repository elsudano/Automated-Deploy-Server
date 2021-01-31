# module "aws" {
#   source = "../../providers/aws"
# }
module "aws_centos" {
  source = "../../amis/aws_centos"
}
module "aws_net" {
  source       = "../../networking/aws_net"
}
resource "aws_key_pair" "deployer" {
  key_name   = "deployer_key"
  public_key = file(var.public_key)
}
resource "aws_instance" "aws_frontend" {
  ami                         = module.aws_centos.centos_7_id
  instance_type               = "t2.micro"
  subnet_id                   = module.aws_net.aws_subnet_id
  vpc_security_group_ids      = [module.aws_net.aws_security_group_id]
  # associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.key_name
  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }
  
  tags = {
    Name = "AWS_FRONTEND"
  }
  depends_on = [module.aws_net]
}