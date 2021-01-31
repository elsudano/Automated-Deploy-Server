# module "aws" {
#   source = "../../providers/aws"
# }
resource "aws_vpc_dhcp_options" "aws_dhcp" {
  domain_name          = "eu-west-1.compute.internal"
  domain_name_servers  = ["8.8.8.8", "8.8.4.4", "127.0.0.1", "10.0.0.2"]
  ntp_servers          = ["127.0.0.1"]
  netbios_name_servers = ["127.0.0.1"]
  netbios_node_type    = 2

  tags = {
    Name = "AWS_DHCP"
  }
}
resource "aws_vpc" "aws_vpc" {
  cidr_block       = "10.0.0.0/16"
  # instance_tenancy = "dedicated"
  tags = {
    Name = "AWS_VPC"
  }
}
resource "aws_vpc_dhcp_options_association" "aws_vpc_dhcp" {
  vpc_id          = aws_vpc.aws_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.aws_dhcp.id
}
resource "aws_default_security_group" "default" {
  vpc_id      = aws_vpc.aws_vpc.id
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.aws_vpc.cidr_block]
  }
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.aws_vpc.cidr_block]
  }
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.aws_vpc.cidr_block]
  }
  egress {
    description = "Out direction from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_common"
  }
}
resource "aws_internet_gateway" "aws_gateway" {
  vpc_id = aws_vpc.aws_vpc.id
  tags = {
    Name = "AWS_GATEWAY"
  }
}
resource "aws_subnet" "aws_subnet" {
  vpc_id                  = aws_vpc.aws_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "AWS_SUBNET"
  }
}
resource "aws_eip" "aws_eip" {
  vpc = true
  depends_on                = [aws_internet_gateway.aws_gateway]
}