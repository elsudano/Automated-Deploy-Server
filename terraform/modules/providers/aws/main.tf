provider "aws" {
  version = "~> 2.67.0"
  region = "eu-west-1"
  assume_role {
    role_arn     = "arn:aws:iam::844241806016:role/aws-service-role/support.amazonaws.com/AWSServiceRoleForSupport"
    session_name = "terraform"
  }
}
