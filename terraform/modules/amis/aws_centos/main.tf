module "aws" {
  source = "../../providers/aws"
}
data "aws_ami" "centos_7" {
  most_recent = true
  # filter {
  #   name   = "name"
  #   values = ["CentOS*-7-*Minimal*20200428*87*"]
  # }
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
  owners = ["434481986642"]
}
data "aws_ami" "centos_8" {
  most_recent = true
  # filter {
  #   name   = "name"
  #   values = ["CentOS*-8-*Minimal*20200407*84*"]
  # }
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
  owners = ["434481986642"]
}
data "aws_ami" "centos_custom" {
  most_recent = true
  # filter {
  #   name   = "name"
  #   values = ["CentOS-",var.centos_version,"-*Minimal*",var.centos_ami_creation_day,"*"]
  # }
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
  owners = ["434481986642"]
}
