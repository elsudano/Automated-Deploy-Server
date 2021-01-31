terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 0.14.5"
}
provider "aws" {
  # Configuration options
}