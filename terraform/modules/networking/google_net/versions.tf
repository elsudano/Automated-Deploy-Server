terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
  required_version = ">= 0.14.5"
}
provider "google" {
  # Configuration options
}