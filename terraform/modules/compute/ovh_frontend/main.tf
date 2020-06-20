module "ovh" {
  source = "../../providers/ovh"
}
resource "ovh_me_ssh_key" "default" {
  name = "SSH Key"
  key  = file(var.public_key)
}
resource "ovh_dedicated_server" "myvps" {
  name               = var.ovh_name_vps
  image              = var.ovh_image_vps
  ssh_keys           = [ovh_me_ssh_key.default.id]


  provisioner "remote-exec" {
    inline = ["sudo yum update -y"]
  }
  
  connection {
    type        = "ssh"
    host        = ovh_dedicated_server.myvps.ipv4_address
    user        = "root"
    password    = ""
    private_key = file(var.private_key)
  }
}
