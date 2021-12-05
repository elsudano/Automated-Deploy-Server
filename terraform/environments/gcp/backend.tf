terraform {
  backend "gcs" {
    bucket      = "storage-helper-sudano-net"
    credentials = "../../vault/terraform-base-sudano-net.json"
    prefix      = "environments/pro"
  }
}