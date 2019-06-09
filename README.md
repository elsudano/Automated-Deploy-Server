# Automated deploy my server

In this project I going to automate the deploy of my server, in it which now have installed Nextcloud, Webmin, PostgreSQL, MariaDB, Cockpit and some customizations of OS

# How to use:

For the fastest users, this is the way to start implementing it on the server, after that just change the value of the variables in all ansible roles and be careful not to load the modified files into your repository.

The other way for this action is to use a storage file inside the vault to assign value to the variables in all the roles.

```bash
git clone https://github.com/elsudano/Automated-Deploy-Server.git
export EDITOR="nano"
make bootstrap
```

# Terraform

For create the infrastructure of my server I'm using Terraform because is possible make test in VirtualBOX, AWS or DigitalOcean.

#### 1. Pre-Requisites


# Ansible

#### 1. Pre-Requisites

#### 2. Install roles

```bash
cd ansible/
ansible-galaxy install -r requirements.yml -p roles/
```
