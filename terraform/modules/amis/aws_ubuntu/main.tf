module "aws" {
  source = "../../providers/aws"
}
data "aws_ami" "ubuntu_1404" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "image-type"
    values = ["machine"]
  }
  filter {
    name   = "block-device-mapping.delete-on-termination"
    values = ["true"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"] # Canonical
}
data "aws_ami" "ubuntu_1804" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/*18.04-amd64-server-20200611*"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "image-type"
    values = ["machine"]
  }
  filter {
    name   = "block-device-mapping.delete-on-termination"
    values = ["true"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"] # Canonical
}
data "aws_ami" "ubuntu_custom" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd","*server*",var.ubuntu_version,var.ubuntu_ami_creation_day]
  }
  filter {
    name   = "state"
   values = ["available"]
 }
 filter {
   name   = "image-type"
   values = ["machine"]
 }
 filter {
   name   = "block-device-mapping.delete-on-termination"
   values = ["true"]
 }
 filter {
   name   = "virtualization-type"
   values = ["hvm"]
 }
 filter {
   name   = "architecture"
   values = ["x86_64"]
 }
  owners = ["099720109477"] # Canonical
}
