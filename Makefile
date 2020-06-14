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
# PUBLIC_IP = $(shell cat terraform.tfstate | jq '.resources[] | select(.type == "digitalocean_droplet") | .instances[].attributes.ipv4_address' | tr -d \")
PUBLIC_IP = $(shell cat terraform.tfstate | jq '.resources[] | select(.type == "google_compute_instance") | .instances[0].attributes.network_interface[0].access_config[0].nat_ip' | tr -d \")
INSTANCE = $(shell cat terraform.tfstate | jq '.resources[] | select(.type == "google_compute_instance") | .instances[0].attributes.id' | tr -d \")
DOMAIN = $(shell cat terraform.tfstate | jq '.resources[] | select(.type == "ovh_domain_zone_record") | .instances[0].attributes.subdomain,.instances[0].attributes.zone' | tr -d \" | tr "\n" . | rev  | cut -c 2- | rev)
OS = $(shell hostnamectl | grep "Operating System:" | awk -F\  '{ print $$3 }')
ARCH = $(shell hostnamectl | grep "Architecture:" | awk -F\  '{ print $$2 }')
TFVER = 0.12.8

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
02_bootstrap: --check_vault_file --requirements --dev_terraform_init ## Prepare environment for deploy automatically

PHONY += dev_deploy_check
03_dev_deploy_check: 17_decrypt --dev_deploy_check 16_encrypt ## Check the modify of deploy the new infrastructure for environment of develop 

PHONY += dev_deploy_run
04_dev_deploy_run: 17_decrypt --dev_deploy_run 16_encrypt ## Deploy new infrastructure for environment of develop

PHONY += pre_deploy_check
05_pre_deploy_check: 17_decrypt --pre_deploy_check 16_encrypt ## Check the modify of deploy the new infrastructure for environment of pre-production

PHONY += pre_deploy_run
06_pre_deploy_run: 17_decrypt --pre_deploy_run 16_encrypt ## Deploy new infrastructure for environment of pre-production

09_ansible-check: ansible/root.yml ## Verify all task for in the servers but not apply configuration, extra vars supported EXTRA="-vvv"
	@echo "ansible-playbook ansible/root.yml --diff --check --vault-password-file $(VAULT_ANSIBLE)/credentials.txt --inventory ansible/inventory $(EXTRA)"
	@ansible-playbook ansible/root.yml --diff --check --vault-password-file $(VAULT_ANSIBLE)/credentials.txt --inventory ansible/inventory $(EXTRA)

10_ansible-run: ansible/root.yml ## Run all task necessary for the correct functionality, extra vars supported EXTRA="-vvv"
	@ansible-playbook ansible/root.yml --diff --vault-password-file $(VAULT_ANSIBLE)/credentials.txt --inventory ansible/inventory $(EXTRA)

PHONY += upload
11_upload: 16_encrypt --upload ## Encrypt vault files and add, commit the files with message, for e.g. upload MESSAGE="Add files"

PHONY += download
12_download: --download 17_decrypt ## Downloading the files and decrypt vault files for editing ¡¡WARNING!! this operation remove all changes without commiting

PHONY += connect
13_connect: 17_decrypt --connect 16_encrypt ## Connect to the remote instance with the key for deployment

14_poweron: ## Power on the instance
	@gcloud compute instances start $(INSTANCE)

PHONY += poweroff
15_poweroff: 17_decrypt --poweroff 16_encrypt ## Power off the instance

16_encrypt: ## Encrypt files for uploading to repository
	# @ansible-vault encrypt $(VAULT_ANSIBLE)/*.yml > /dev/null
	@ansible-vault encrypt $(VAULT_ANSIBLE)/*.sh > /dev/null
	# @ansible-vault encrypt $(VAULT_ANSIBLE)/*.json > /dev/null
	@ansible-vault encrypt $(VAULT_ANSIBLE)/*.ini > /dev/null
	@ansible-vault encrypt $(VAULT_ANSIBLE)/.ovhapi > /dev/null
	@ansible-vault encrypt ansible/group_vars/all/vault > /dev/null
	@ansible-vault encrypt $(VAULT_TERRAFORM)/*.tfvars > /dev/null
	@ansible-vault encrypt $(VAULT_TERRAFORM)/*.json > /dev/null

17_decrypt: ## Decrypt files for working with them
	# @ansible-vault decrypt $(VAULT_ANSIBLE)/*.yml > /dev/null
	@ansible-vault decrypt $(VAULT_ANSIBLE)/*.sh > /dev/null
	# @ansible-vault decrypt $(VAULT_ANSIBLE)/*.json > /dev/null
	@ansible-vault decrypt $(VAULT_ANSIBLE)/*.ini > /dev/null
	@ansible-vault decrypt $(VAULT_ANSIBLE)/.ovhapi > /dev/null
	@ansible-vault decrypt ansible/group_vars/all/vault > /dev/null
	@ansible-vault decrypt $(VAULT_TERRAFORM)/*.tfvars > /dev/null
	@ansible-vault decrypt $(VAULT_TERRAFORM)/*.json > /dev/null

PHONY += dev_remove
18_dev_remove: 17_decrypt --dev_remove 16_encrypt  ## Un-Deploy all infrestructure the environment of develop

PHONY += pre_remove
19_pre_remove: 17_decrypt --pre_remove 16_encrypt  ## Un-Deploy all infrestructure the environment of pre-production

20_soft_clean: 16_encrypt ## Clean the project, this only remove all Roles and temporary files, use with careful
	@rm -fR ansible/roles/*
	@rm -fR .terraform/
	@rm -f /tmp/terraform*
	@rm -fR ./*.backup

PHONY += hard_clean
21_hard_clean: 13_soft_clean --removeTerraform --clean$(OS) ## Clean the project, !!WARNING¡¡ all data storage in roles folder be removed, and the programs using deleted too!!!

#-------------------------------------------------------#
#    Private Functions                                  #
#-------------------------------------------------------#
--Fedora:
	@sudo dnf install -y wget.x86_64 unzip.x86_64 python3-fabric.noarch python3-dnf.noarch ansible.noarch
--Ubuntu:
	@sudo apt update -y
	@sudo apt install -y wget unzip fabric ansible
--i386:
	@wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TFVER}/terraform_${TFVER}_linux_386.zip
--x86-64:
	@wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TFVER}/terraform_${TFVER}_linux_amd64.zip

--requirements: ansible/requirements.yml
	@ansible-galaxy install -r ansible/requirements.yml -p ansible/roles/ --force

--dev_deploy_check: --dev_terraform_init --check_vault_file 
	@source $(VAULT_ANSIBLE)/env_vars_ovh.sh; terraform plan -var-file="$(VAULT_TERRAFORM)/terraform.tfvars" $(DEVDIR)

--dev_deploy_run: --dev_terraform_init --check_vault_file 
	@source $(VAULT_ANSIBLE)/env_vars_ovh.sh; terraform apply -var-file="$(VAULT_TERRAFORM)/terraform.tfvars" $(DEVDIR)

--pre_deploy_check: --pre_terraform_init --check_vault_file 
	@source $(VAULT_ANSIBLE)/env_vars_ovh.sh; terraform plan -var-file="$(VAULT_TERRAFORM)/terraform.tfvars" $(PREDIR)

--pre_deploy_run: --pre_terraform_init --check_vault_file 
	@source $(VAULT_ANSIBLE)/env_vars_ovh.sh; terraform apply -var-file="$(VAULT_TERRAFORM)/terraform.tfvars" $(PREDIR)

--dev_remove: $(VAULT_TERRAFORM)/terraform.tfvars
	@source $(VAULT_ANSIBLE)/env_vars_ovh.sh; terraform destroy -var-file="$(VAULT_TERRAFORM)/terraform.tfvars" $(DEVDIR)

--pre_remove: $(VAULT_TERRAFORM)/terraform.tfvars
	@source $(VAULT_ANSIBLE)/env_vars_ovh.sh; terraform destroy -var-file="$(VAULT_TERRAFORM)/terraform.tfvars" $(PREDIR)

--connect: $(PRIVATE_KEY) $(VAULT_TERRAFORM)/terraform.tfvars
	@ssh -l $(shell cat $(VAULT_TERRAFORM)/terraform.tfvars | grep "ssh_user" | awk -F\  '{ print $$3 }' | tr -d \") -i $(PRIVATE_KEY) $(EXTRA_SSH_COMMAND) $(DOMAIN)

--poweroff: $(PRIVATE_KEY) $(VAULT_TERRAFORM)/terraform.tfvars
	@ssh -l $(shell cat $(VAULT_TERRAFORM)/terraform.tfvars | grep "ssh_user" | awk -F\  '{ print $$3 }' | tr -d \") -i $(PRIVATE_KEY) $(EXTRA_SSH_COMMAND) $(DOMAIN) sudo shutdown -P +1

--check_vault_file: $(VAULT_ANSIBLE)/credentials.txt $(VAULT_ANSIBLE)/env_vars_ovh.sh
	@bash -c 'if [ ! -s $(VAULT_ANSIBLE)/credentials.txt ]; then echo "Please create the $(VAULT_ANSIBLE)/credentials.txt file with the password inside"; fi;'
	@bash -c 'if [ ! -s $(VAULT_ANSIBLE)/env_vars_ovh.sh ]; then echo "Please create and complete the $(VAULT_ANSIBLE)/env_vars_ovh.sh file with correct values inside"; fi;'

--dev_terraform_init: $(VAULT_TERRAFORM)/terraform.tfvars $(DEVDIR)/main.tf $(DEVDIR)/variables.tf $(DEVDIR)/outputs.tf
	@terraform init -var-file="$(VAULT_TERRAFORM)/terraform.tfvars" $(DEVDIR)

--pre_terraform_init: $(VAULT_TERRAFORM)/terraform.tfvars $(PREDIR)/main.tf $(PREDIR)/variables.tf $(PREDIR)/outputs.tf
	@terraform init -var-file="$(VAULT_TERRAFORM)/terraform.tfvars" $(PREDIR)

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
