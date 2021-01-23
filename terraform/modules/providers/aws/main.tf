terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.25.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  assume_role {
    role_arn     = "arn:aws:iam::844241806016:role/aws-service-role/support.amazonaws.com/AWSServiceRoleForSupport"
    session_name = "terraform"
  }
}
