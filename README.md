# Automated deploy my server

In this project I going to automate the deploy of my server, in it which now have installed Nextcloud, Webmin, PostgreSQL, MariaDB, Cockpit and some customizations of OS

# Use quickly:

For the fastest users, this is the way to start implementing it on the server, after that just change the value of the variables in all ansible roles and be careful not to load the modified files into your repository.

The other way for this action is to use a storage file inside the vault to assign value to the variables in all the roles.

```bash
git clone https://github.com/elsudano/Automated-Deploy-Server.git
echo "password" > ansible/vault/credentials.txt
export EDITOR="nano"
make 01_prerequisites
make 02_bootstrap
```

Keep in mind that the `EDITOR` variable is setting only in session, for the setting be permanent is necessary put in your `~/.bashrc` the next line: `export EDITOR="nano"`

# How to use:

For normal use, I have created a Makefile with some commands to help us, with `make` show in screen the usage help.

# Terraform

For create the infrastructure of my server I'm using Terraform because is possible make test in VirtualBOX, AWS, DigitalOcean and OVH.

#### 1. Pre-Requisites

For create the necessary infrastructure is needed install Terraform in your system, for that run `make 01 prerequisites` in the root path of the project

# Ansible

With this program we installing and setting our remote server

#### 1. Pre-Requisites

#### 2. Install roles

```bash
cd ansible/
ansible-galaxy install -r requirements.yml -p roles/
```
