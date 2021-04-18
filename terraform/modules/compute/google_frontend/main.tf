module "google_net" {
  source          = "../../networking/google_net"
  storage_project = var.storage_project
  vpc_name        = var.vpc_name
  firewall_name   = var.firewall_name
}
resource "google_compute_instance" "google_frontend" {
  name         = var.reource_frontend_name
  machine_type = var.reource_frontend_machine_type
  # Optionals attributes but utils for management  
  allow_stopping_for_update = "true"
  description               = "Instance frontend for Nextcloud"
  deletion_protection       = var.delete_protection
  project                   = var.storage_project

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    # network = "default"
    network = module.google_net.vpc_link
    access_config {
    }
  }

  metadata = {
    block-project-ssh-keys = "true"
    ssh-keys               = "${var.ssh_user}:${file(var.public_key)}"
  }

  scheduling {
    automatic_restart   = "false"
    on_host_maintenance = "MIGRATE"
    preemptible         = "false"
  }

  tags = ["access-from-internet"]
  # provisioner "file" {
  #   source      = "ansible/vault/docker-compose.yml"
  #   destination = "~/docker-compose.yml"
  # }
  # # provisioner "remote-exec" {
  # #   inline = ["mkdir ~/config"]
  # # }
  # provisioner "file" {
  #   source      = "ansible/vault/ovh.ini"
  #   destination = "~/ovh.ini"
  # }
  # provisioner "file" {
  #   source      = "ansible/vault/daemon.json"
  #   destination = "~/daemon.json"
  # }
  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo systemctl stop firewalld",
  #     "sudo systemctl disable firewalld",
  #     "sudo yum -y update",
  #     "sudo yum -y install git ansible nano docker docker-compose",
  #     "sudo systemctl start docker",
  #     "sudo systemctl enable docker",
  #     "sudo usermod -aG dockerroot ${var.ssh_user}",
  #     "sudo mv ~/daemon.json /etc/docker/daemon.json",
  #     "sudo chown root:root /etc/docker/daemon.json",
  #     "sudo chmod 644 /etc/docker/daemon.json",
  #     "sudo chmod 666 /var/run/docker.sock",
  #   ]
  # }
  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo systemctl restart docker",
  #     "docker network create nextcloud_network",
  #     "docker-compose up -d"
  #   ]
  # }
  connection {
    type        = "ssh"
    host        = google_compute_instance.google_frontend.network_interface[0].access_config[0].nat_ip
    user        = var.ssh_user
    password    = ""
    timeout     = "240s"
    private_key = file(var.private_key)
  }
}
