SHELL = /bin/bash

VAULT_ANSIBLE = ansible/vault
VAULT_TERRAFORM = terraform/vault
PROVARS = $(VAULT_TERRAFORM)/pro.tfvars
PREVARS = $(VAULT_TERRAFORM)/pre.tfvars
DEVVARS = $(VAULT_TERRAFORM)/dev.tfvars
PRIVATE_KEY = ~/.ssh/id_rsa_deploying
EXTRA_SSH_COMMAND = -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
BASE_TERRAFORM = terraform/environments
PRODIR = $(BASE_TERRAFORM)/00-pro
PREDIR = $(BASE_TERRAFORM)/01-pre
DEVDIR = $(BASE_TERRAFORM)/02-dev
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
02_bootstrap: --check_vault_file --requirements --terraform_init ## Prepare environment for deploy automatically

PHONY += deploy_check
03_deploy_check: 17_decrypt --setEnviVar --deploy_check --settingVars 16_encrypt ## Check the modify of deploy the new infrastructure for environment to setting in ENVI var 

PHONY += deploy_run
04_deploy_run: 17_decrypt --setEnviVar --deploy_run --settingVars 16_encrypt ## Deploy new infrastructure for environment to setting in ENVI var

PHONY += dev_remove
05_infra_remove: 17_decrypt --setEnviVar --infra_remove 16_encrypt  ## Un-Deploy all infrestructure the environment of develop

06_ansible-check: ansible/root.yml ## Verify all task for in the servers but not apply configuration, extra vars supported EXTRA="-vvv"
	@echo "ansible-playbook ansible/root.yml --diff --check --vault-password-file $(VAULT_ANSIBLE)/credentials.txt --inventory ansible/inventory $(EXTRA)"
	@ansible-playbook ansible/root.yml --diff --check --vault-password-file $(VAULT_ANSIBLE)/credentials.txt --inventory ansible/inventory $(EXTRA)

07_ansible-run: ansible/root.yml ## Run all task necessary for the correct functionality, extra vars supported EXTRA="-vvv"
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

18_soft_clean: 16_encrypt ## Clean the project, this only remove all Roles and temporary files, use with careful
	@rm -fR ansible/roles/*
	@rm -fR .terraform/
	@rm -f /tmp/terraform*
	@rm -fR ./*.backup

PHONY += hard_clean
19_hard_clean: 13_soft_clean --removeTerraform --clean$(OS) ## Clean the project, !!WARNING¡¡ all data storage in roles folder be removed, and the programs using deleted too!!!

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

--deploy_check: --terraform_init --check_vault_file 
	@source $(VAULT_ANSIBLE)/env_vars_ovh.sh; terraform plan -var-file="$(ENVIVARS)" $(ENVIDIR)

--deploy_run: --terraform_init --check_vault_file 
	@source $(VAULT_ANSIBLE)/env_vars_ovh.sh; terraform apply -var-file="$(ENVIVARS)" $(ENVIDIR)

--infra_remove: $(ENVIVARS)
	@source $(VAULT_ANSIBLE)/env_vars_ovh.sh; terraform destroy -var-file="$(ENVIVARS)" $(ENVIDIR)

--connect: $(PRIVATE_KEY) $(ENVIVARS)
	@ssh -l $(shell cat $(ENVIVARS) | grep "ssh_user" | awk -F\  '{ print $$3 }' | tr -d \") -i $(PRIVATE_KEY) $(EXTRA_SSH_COMMAND) $(DOMAIN)

--poweroff: $(PRIVATE_KEY) $(ENVIVARS)
	@ssh -l $(shell cat $(ENVIVARS) | grep "ssh_user" | awk -F\  '{ print $$3 }' | tr -d \") -i $(PRIVATE_KEY) $(EXTRA_SSH_COMMAND) $(DOMAIN) sudo shutdown -P +1

--check_vault_file: $(VAULT_ANSIBLE)/credentials.txt $(VAULT_ANSIBLE)/env_vars_ovh.sh
	@bash -c 'if [ ! -s $(VAULT_ANSIBLE)/credentials.txt ]; then echo "Please create the $(VAULT_ANSIBLE)/credentials.txt file with the password inside"; fi;'
	@bash -c 'if [ ! -s $(VAULT_ANSIBLE)/env_vars_ovh.sh ]; then echo "Please create and complete the $(VAULT_ANSIBLE)/env_vars_ovh.sh file with correct values inside"; fi;'

--terraform_init: $(ENVIVARS) #$(ENVIDIR)/main.tf $(ENVIDIR)/variables.tf $(ENVIDIR)/outputs.tf
	@stat $(ENVIDIR)/main.tf
	@stat $(ENVIDIR)/variables.tf
	@stat $(ENVIDIR)/outputs.tf
	@terraform init -var-file="$(ENVIVARS)" $(ENVIDIR)

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

--setEnviVar:
ifeq ($(ENVI),)
	$(error ENVI is not set)
else ifeq ($(ENVI),PRO)
	$(eval ENVIDIR := $(PRODIR))
	$(eval ENVIVARS := $(PROVARS))
else ifeq ($(ENVI),PRE)
	$(eval ENVIDIR := $(PREDIR))
	$(eval ENVIVARS := $(PREVARS))
else ifeq ($(ENVI),DEV)
	$(eval ENVIDIR := $(DEVDIR))
	$(eval ENVIVARS := $(DEVVARS))
endif

--settingVars:
ifeq ($(ENVI),PRO)
	$(eval PUBLIC_IP := $(shell cat $(ENVIDIR)/terraform.tfstate | jq '.resources[] | select(.type == "digitalocean_droplet") | .instances[].attributes.ipv4_address' | tr -d \"))
	$(eval INSTANCE := $(shell cat $(ENVIDIR)/terraform.tfstate | jq '.resources[] | select(.type == "google_compute_instance") | .instances[0].attributes.id' | tr -d \"))
	$(eval DOMAIN := $(shell cat $(ENVIDIR)/terraform.tfstate | jq '.resources[] | select(.type == "ovh_domain_zone_record") | .instances[0].attributes.subdomain,.instances[0].attributes.zone' | tr -d \" | tr "\n" . | rev  | cut -c 2- | rev))
else ifeq ($(ENVI),PRE)
	$(eval PUBLIC_IP := $(shell cat $(ENVIDIR)/terraform.tfstate | jq '.resources[] | select(.type == "google_compute_instance") | .instances[0].attributes.network_interface[0].access_config[0].nat_ip' | tr -d \"))
	$(eval INSTANCE := $(shell cat $(ENVIDIR)/terraform.tfstate | jq '.resources[] | select(.type == "google_compute_instance") | .instances[0].attributes.id' | tr -d \"))
	$(eval DOMAIN := $(shell cat $(ENVIDIR)/terraform.tfstate | jq '.resources[] | select(.type == "ovh_domain_zone_record") | .instances[0].attributes.subdomain,.instances[0].attributes.zone' | tr -d \" | tr "\n" . | rev  | cut -c 2- | rev))
else ifeq ($(ENVI),DEV)
	$(eval PUBLIC_IP := "localhost")
	$(eval INSTANCE := "")
	$(eval DOMAIN := "")
endif

.PHONY = $(PHONY)
