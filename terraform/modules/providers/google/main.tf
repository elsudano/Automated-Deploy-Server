terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.53.0"
    }
  }
  required_version = ">= 0.13"
}

provider "google" {
  # Configuration options
}