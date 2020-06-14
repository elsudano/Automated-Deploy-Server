module "do" {
  source        = "../../providers/do"
}
resource "digitalocean_ssh_key" "default" {
  name       = "SSH Key"
  public_key = file(var.public_key)
}
resource "digitalocean_droplet" "first_droplet_small" {
  name               = var.do_name_droplet
  image              = var.do_image_droplet
  region             = "lon1"
  size               = "s-1vcpu-1gb"
  backups            = false
  monitoring         = false
  ipv6               = false
  private_networking = true
  ssh_keys           = [digitalocean_ssh_key.default.id]
  resize_disk        = false
  tags               = var.do_tags_droplet

  provisioner "remote-exec" {
    inline = ["sudo yum update -y"]
  }
  
  connection {
    type        = "ssh"
    host        = digitalocean_droplet.first_droplet_small.ipv4_address
    user        = "root"
    password    = ""
    private_key = file(var.private_key)
  }
}
