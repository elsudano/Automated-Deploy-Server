# Automated deploy my server

In this project I going to automate the deploy of my server, in it which now have installed Nextcloud, Webmin, PostgreSQL, MariaDB, Cockpit and some customizations of OS

# Use quickly:

For the fastest users, this is the way to start implementing it on the server, after that just change the value of the variables in all ansible roles and be careful not to load the modified files into your repository.

The other way for this action is to use a storage file inside the vault to assign value to the variables in all the roles.

```bash
git clone https://github.com/elsudano/Automated-Deploy-Server.git
export EDITOR="nano"
make bootstrap
```

Keep in mind that the `EDITOR` variable is setting only in session, for the setting be permanent is necessary put in your `~/.bashrc` the next line: `export EDITOR="nano"`

# How to use:

For normal use, I have created a Makefile with some commands to help us, among them are the following:

* `make` This command show in screen the usage help.
* `make bootstrap` This command prepare the environment for working.
* `make upload MESSAGE="whatever"` This command run encrypt vault files, git add, git commit with MESSAGE and push changes to repository.
* `make download` This command run git pull and decrypt vault files.
* `make encrypt` This command encrypt the vault files for uploading to repository
* `make decrypt` This command decrypt the vault files for modify them
* `make ansible-check` This command check if deploy is correct in the servers.
* `make ansible-run` This command run deploy on servers.

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
