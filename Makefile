SHELL = /bin/bash

VAULT_ANSIBLE = ansible/vault
VAULT_TERRAFORM = terraform/vault
PRIVATE_KEY = ~/.ssh/id_rsa_deploying
EXTRA_SSH_COMMAND = -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
BASE_TERRAFORM = terraform/environments
PRODIR = $(BASE_TERRAFORM)/00-pro
PREDIR = $(BASE_TERRAFORM)/01-pre
DEVDIR = $(BASE_TERRAFORM)/02-dev
# This has to be solved, because when there is more than one it is a problem
PUBLIC_IP = $(shell cat terraform.tfstate | jq '.resources[] | select(.type == "digitalocean_droplet") | .instances[].attributes.ipv4_address' | tr -d \")
OS = $(shell hostnamectl | grep "Operating System:" | awk -F\  '{ print $$3 }')
ARCH = $(shell hostnamectl | grep "Architecture:" | awk -F\  '{ print $$2 }')
TFVER = 0.12.0

#-------------------------------------------------------#
#    Public Functions                                   #
#-------------------------------------------------------#
PHONY += help
help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort | awk 'BEGIN {FS = ":.*?## "}; \
	{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

PHONY += prerequisites
01_prerequisites: --$(OS) --$(ARCH) ## Prepare of environment and install programs needed for deploying
	@unzip -q -o -d /tmp /tmp/terraform.zip
	@sudo mv /tmp/terraform /usr/bin/

PHONY += bootstrap 
02_bootstrap: --vault --requirements --dev_terraform_init ## Prepare environment for deploy automatically

PHONY += upload
08_upload: 10_encrypt --upload 11_decrypt ## Encrypt vault files and add, commit the files with message, for e.g. upload MESSAGE="Add files"

PHONY += download
09_download: --download 11_decrypt ## Downloading the files and decrypt vault files for editing ¡¡WARNING!! this operation remove all changes without commiting

10_encrypt: ## Encrypt files for uploading to repository
	@ansible-vault encrypt $(VAULT_ANSIBLE)/*.yml > /dev/null
	@ansible-vault encrypt $(VAULT_ANSIBLE)/env_vars_ovh.sh > /dev/null
	@ansible-vault encrypt $(VAULT_TERRAFORM)/*.tfvars > /dev/null

11_decrypt: ## Decrypt files for working with them
	@ansible-vault decrypt $(VAULT_ANSIBLE)/*.yml > /dev/null
	@ansible-vault decrypt $(VAULT_ANSIBLE)/env_vars_ovh.sh > /dev/null
	@ansible-vault decrypt $(VAULT_TERRAFORM)/*.tfvars > /dev/null

03_dev_deploy_check: --dev_terraform_init --check_vault_file ## Check the modify of deploy the new infrastructure for environment of develop
	@source $(VAULT_ANSIBLE)/env_vars_ovh.sh; terraform plan -var-file="$(VAULT_TERRAFORM)/terraform.tfvars" $(DEVDIR)

04_dev_deploy_run: --dev_terraform_init --check_vault_file ## Deploy new infrastructure for environment of develop
	@source $(VAULT_ANSIBLE)/env_vars_ovh.sh; terraform apply -var-file="$(VAULT_TERRAFORM)/terraform.tfvars" $(DEVDIR)

12_dev_remove: $(VAULT_TERRAFORM)/terraform.tfvars ## Un-Deploy all infrestructure the environment of develop
	@source $(VAULT_ANSIBLE)/env_vars_ovh.sh; terraform destroy -var-file="$(VAULT_TERRAFORM)/terraform.tfvars" $(DEVDIR)

05_ansible-check: ansible/root.yml ## Verify all task for in the servers but not apply configuration
	@ansible-playbook ansible/root.yml --diff --check -u centos -i $(PUBLIC_IP),

06_ansible-run: ansible/root.yml ## Run all task necessary for the correct functionality
	@ansible-playbook ansible/root.yml --diff -u centos -i $(PUBLIC_IP),

07_connect: $(PRIVATE_KEY) ## Connect to the remote instance with the key for deployment
	@ssh -l centos -i $(PRIVATE_KEY) $(EXTRA_SSH_COMMAND) $(PUBLIC_IP)

13_soft_clean: 10_encrypt ## Clean the project, this only remove all Roles and temporary files, use with careful
	@rm -fR ansible/roles/*
	@rm -fR .terraform/
	@rm -f *.tfstate
	@rm -f /tmp/terraform*
	@rm -fR ./*.backup

PHONY += hard_clean
14_hard_clean: 13_soft_clean --removeTerraform --clean$(OS) ## Clean the project, !!WARNING¡¡ all data storage in roles folder be removed, and the programs using deleted too!!!

#-------------------------------------------------------#
#    Private Functions                                  #
#-------------------------------------------------------#
--Fedora:
	@sudo dnf install wget.x86_64 unzip.x86_64 python3-fabric.noarch ansible.noarch -y
--Ubuntu:
	@sudo apt update -y
	@sudo apt install wget unzip fabric ansible -y
--i386:
	@wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TFVER}/terraform_${TFVER}_linux_386.zip
--x86-64:
	@wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TFVER}/terraform_${TFVER}_linux_amd64.zip

--requirements: ansible/requirements.yml
	@ansible-galaxy install -r ansible/requirements.yml -p ansible/roles/ --force

--vault: --check_vault_file $(VAULT_ANSIBLE)/credentials.txt
	@ansible-vault decrypt $(VAULT_ANSIBLE)/*.yml > /dev/null
	@ansible-vault decrypt $(VAULT_ANSIBLE)/env_vars_ovh.sh > /dev/null
	@ansible-vault decrypt $(VAULT_TERRAFORM)/*.tfvars > /dev/null

--check_vault_file:
	@bash -c 'if [ ! -s $(VAULT_ANSIBLE)/credentials.txt ]; then echo "Please create the $(VAULT_ANSIBLE)/credentials.txt file with the password inside"; fi;'
	@bash -c 'if [ ! -s $(VAULT_ANSIBLE)/env_vars_ovh.sh ]; then echo "Please create and complete the $(VAULT_ANSIBLE)/env_vars_ovh.sh file with correct values inside"; fi;'

--dev_terraform_init: $(VAULT_TERRAFORM)/terraform.tfvars $(DEVDIR)/main.tf $(DEVDIR)/variables.tf $(DEVDIR)/outputs.tf
	@terraform init -var-file="$(VAULT_TERRAFORM)/terraform.tfvars" $(DEVDIR)

--upload: 
	@git add .
	@git commit -m "$(MESSAGE)"
	@git push

--download:
	@git checkout -- .
	@git pull --rebase

--removeTerraform:
	@sudo rm -f /usr/bin/terraform
--cleanFedora:
	@sudo dnf remove wget.x86_64 unzip.x86_64 python3-fabric.noarch ansible.noarch -y
--cleanUbuntu:
	@sudo apt remove wget unzip fabric ansible -y

.PHONY = $(PHONY)
