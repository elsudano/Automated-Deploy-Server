module "google" {
  source = "../../providers/google"
}
module "google_net" {
  source               = "../../networking/google_net"
  google_vpc_name      = "${var.google_vpc_name}"
  google_firewall_name = "${var.google_firewall_name}"
}
resource "google_compute_instance" "google_frontend" {
  name         = "${var.google_reource_frontend_name}"
  machine_type = "${var.google_reource_frontend_machine_type}"
  # Optionals attributes but utils for management  
  allow_stopping_for_update = "true"
  description               = "Instance frontend for Nextcloud, just nginx"
  deletion_protection       = "true"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    # network = "default"
    network = "${module.google_net.google_vpc_link}"
    access_config {
    }
  }

  metadata = {
    block-project-ssh-keys = "true"
    ssh-keys = "${var.ssh_user}:${file(var.public_key)}"
  }

  scheduling {
    automatic_restart   = "false"
    on_host_maintenance = "MIGRATE"
    preemptible         = "false"
  }

  tags = ["access-from-internet"]

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum -y install git ansible",
      "sudo systemctl stop firewalld",
      "sudo ls -la"
    ]
  }

  connection {
    type        = "ssh"
    host        = "${google_compute_instance.google_frontend.network_interface[0].access_config[0].nat_ip}"
    user        = "${var.ssh_user}"
    password    = ""
    timeout     = "240s"
    private_key = "${file(var.private_key)}"
  }
}
