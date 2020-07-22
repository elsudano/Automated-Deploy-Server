terraform {
  backend "gcs" {
    bucket      = "storage-helper-sudano-net"
    credentials = "terraform/vault/terraform-base-sudano-net.json"
    prefix      = "environments/pro"
  }
}