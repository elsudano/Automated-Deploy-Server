SHELL = /bin/bash

VAULT_ANSIBLE = ansible/vault
VAULT_TERRAFORM = terraform/vault
INVENTORY = ansible/inventory
OVHVARS = $(VAULT_TERRAFORM)/ovh.tfvars
GCPVARS = $(VAULT_TERRAFORM)/gcp.tfvars
AWSVARS = $(VAULT_TERRAFORM)/aws.tfvars
ARMVARS = $(VAULT_TERRAFORM)/arm.tfvars
DOVARS = $(VAULT_TERRAFORM)/do.tfvars
VMWVARS = $(VAULT_TERRAFORM)/vmw.tfvars
PRIVATE_KEY = ~/.ssh/id_rsa_deploying
EXTRA_SSH_COMMAND = -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
BASE_TERRAFORM = terraform/environments
OVHDIR = $(BASE_TERRAFORM)/00-ovh
GCPDIR = $(BASE_TERRAFORM)/01-gcp
AWSDIR = $(BASE_TERRAFORM)/02-aws
ARMDIR = $(BASE_TERRAFORM)/03-arm
DODIR = $(BASE_TERRAFORM)/04-do
VMWDIR = $(BASE_TERRAFORM)/05-vmw
OS = $(shell hostnamectl | grep "Operating System:" | awk -F\  '{ print $$3 }')
ARCH = $(shell hostnamectl | grep "Architecture:" | awk -F\  '{ print $$2 }')

#-------------------------------------------------------#
#    Public Functions                                   #
#-------------------------------------------------------#
PHONY += help
help:
	@echo -e "Some of the follow options it's permmit for ENVI var: "
	@echo -e "\t- OVH deploy OVH server"
	@echo -e "\t- GCP deploy Google server"
	@echo -e "\t- DO deploy Digital Ocean server"
	@echo -e "\t- AWS deploy Amazon server"
	@echo -e "\t- ARM deploy Azure server"
	@echo -e "\t- VMW deploy VmWare Workstation server"
	@echo
	@echo -e "Example commands:"
	@echo -e "\t- make ENVI=GCP 04_deploy_check"
	@echo -e "\t- make ENVI=GCP 09_ansible-run EXTRA=\"-t mariadb\ -vvv""
	@echo
	@echo -e "Useful commands:"
	@echo -e "\t- Make a backup of production server: make ENVI=GCP 09_ansible-run EXTRA=\"-t backup\""
	@echo -e "\t- Update a production server: make ENVI=GCP 09_ansible-run EXTRA=\"-t update\""
	@echo
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort | awk 'BEGIN {FS = ":.*?## "}; \
	{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

PHONY += all
all:
ifeq ($(ENVI),)
	$(error ENVI is not set)
else ifeq ($(ENVI),VMW)
	$(eval TFVER := 0.15.0)
	$(eval TERRAFORM_BIN := /usr/bin/terraform13)
else
	$(eval TFVER := 0.14.4)
	$(eval TERRAFORM_BIN := /usr/bin/terraform)
endif
	@echo -e "Ver: $(TFVER)"
	@echo -e "Bin: $(TERRAFORM_BIN)"

PHONY += prerequisites
01_prerequisites: all --$(OS) --$(ARCH) ## Prepare of environment and install programs needed for deploying
	@unzip -q -o -d /tmp /tmp/terraform.zip
	@sudo mv /tmp/terraform $(TERRAFORM_BIN)

PHONY += 02_cloud_prerequisites
02_cloud_prerequisites: all 17_decrypt --cloud_bootstrap 16_encrypt ## Prepare project of Google to deploy de infrastructure

PHONY += 03_bootstrap 
03_bootstrap: all --check_vault_file --requirements --setEnviVar 17_decrypt --terraform_init 16_encrypt ## Prepare environment for deploy automatically

PHONY += 04_deploy_check
04_deploy_check: all 17_decrypt --setEnviVar --deploy_check 16_encrypt ## Check the modify of deploy the new infrastructure for environment to setting in ENVI var 

PHONY += 05_deploy_run
05_deploy_run: all 17_decrypt --setEnviVar --deploy_run 16_encrypt ## Deploy new infrastructure for environment to setting in ENVI var

PHONY += 06_infra_remove
06_infra_remove: all 17_decrypt --setEnviVar --infra_remove 16_encrypt  ## Un-Deploy all infrestructure the environment of develop

PHONY += 07_create_graph
07_create_graph: all 17_decrypt --setEnviVar --create_graph 16_encrypt ## Generate a graph of the environment structure

08_ansible-check: --setEnviVar ansible/root.yml ## Verify all task for in the servers but not apply configuration, extra vars supported EXTRA="-vvv"
	@echo "ansible-playbook ansible/root.yml --diff --check --vault-password-file $(VAULT_ANSIBLE)/credentials.txt --inventory ansible/inventory -l $(HOSTANSI) $(EXTRA)"
	@ansible-playbook ansible/root.yml --diff --check --vault-password-file $(VAULT_ANSIBLE)/credentials.txt --inventory ansible/inventory -l $(HOSTANSI) $(EXTRA)

09_ansible-run: --setEnviVar ansible/root.yml ## Run all task necessary for the correct functionality, extra vars supported EXTRA="-vvv"
	@ansible-playbook ansible/root.yml --diff --vault-password-file $(VAULT_ANSIBLE)/credentials.txt --inventory ansible/inventory -l $(HOSTANSI) $(EXTRA)

PHONY += upload
11_upload: 16_encrypt --upload ## Encrypt vault files and add, commit the files with message, for e.g. upload MESSAGE="Add files"

PHONY += download
12_download: --download 17_decrypt ## Downloading the files and decrypt vault files for editing ¡¡WARNING!! this operation remove all changes without commiting

PHONY += connect
13_connect: 17_decrypt --connect 16_encrypt ## Connect to the remote instance with the key for deployment

PHONY += poweron
14_poweron: all 17_decrypt --setEnviVar --poweron --deploy_check 16_encrypt ## Power on the instance

PHONY += poweroff
15_poweroff: 17_decrypt --setEnviVar --poweroff 16_encrypt ## Power off the instance

16_encrypt: ## Encrypt files for uploading to repository
	@ansible-vault encrypt $(VAULT_ANSIBLE)/*.sh > /dev/null
	@ansible-vault encrypt $(VAULT_ANSIBLE)/*.ini > /dev/null
	@ansible-vault encrypt $(VAULT_ANSIBLE)/.ovhapi > /dev/null
	@ansible-vault encrypt ansible/group_vars/all/vault > /dev/null
	@ansible-vault encrypt $(VAULT_TERRAFORM)/*.tfvars > /dev/null
	@ansible-vault encrypt $(VAULT_TERRAFORM)/*.json > /dev/null

17_decrypt: ## Decrypt files for working with them
	@ansible-vault decrypt $(VAULT_ANSIBLE)/*.sh > /dev/null
	@ansible-vault decrypt $(VAULT_ANSIBLE)/*.ini > /dev/null
	@ansible-vault decrypt $(VAULT_ANSIBLE)/.ovhapi > /dev/null
	@ansible-vault decrypt ansible/group_vars/all/vault > /dev/null
	@ansible-vault decrypt $(VAULT_TERRAFORM)/*.tfvars > /dev/null
	@ansible-vault decrypt $(VAULT_TERRAFORM)/*.json > /dev/null

18_soft_clean: ## Clean the project, this only remove all Roles and temporary files, use with careful
	@rm -fR ansible/roles/*
	@rm -fR .terraform/
	@rm -f /tmp/terraform*
	@rm -f terraform.txt
	@rm -f environment.svg
	@rm -fR ./*.backup

PHONY += hard_clean
19_hard_clean: 13_soft_clean --removeTerraform --clean$(OS) ## Clean the project, !!WARNING¡¡ all data storage in roles folder be removed, and the programs using deleted too!!!

#-------------------------------------------------------#
#    Private Functions                                  #
#-------------------------------------------------------#
--Fedora:
	@sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	@sudo bash -c 'echo -e \
"[azure-cli]\n\
name=Azure CLI\n\
baseurl=https://packages.microsoft.com/yumrepos/azure-cli\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
	@sudo dnf install -y google-cloud-sdk azure-cli wget.x86_64 unzip.x86_64 python3-fabric.noarch python3-dnf.noarch ansible.noarch

--Ubuntu:
	@sudo apt update -y
	@sudo apt install -y google-cloud-sdk wget unzip fabric ansible

--Manjaro:
	@sudo pacman -Syu --noconfirm community/yay
	@yay
	@yay -Syu --noconfirm aur/google-cloud-sdk community/jq extra/wget extra/graphviz extra/unzip fabric ansible

--i386:
	@wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TFVER}/terraform_${TFVER}_linux_386.zip

--x86-64:
	@wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TFVER}/terraform_${TFVER}_linux_amd64.zip

--requirements: ansible/requirements.yml
	@ansible-galaxy install -r ansible/requirements.yml -p ansible/roles/ --force

--deploy_check: --terraform_init --check_vault_file 
	@source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) plan -var-file=$(ENVIVARS) $(ENVIDIR)

--deploy_run: --terraform_init --check_vault_file 
	@source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) apply -auto-approve -var-file=$(ENVIVARS) $(ENVIDIR)

--infra_remove: $(ENVIVARS)
	@source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) destroy -var-file=$(ENVIVARS) $(ENVIDIR)

--create_graph: $(ENVIVARS)
	@$(TERRAFORM_BIN) graph $(ENVIDIR) | dot -Tsvg > environment.svg

--connect: $(PRIVATE_KEY) $(ENVIVARS)
	@ssh -l $(shell cat $(ENVIVARS) | grep "ssh_user" | awk -F\  '{ print $$3 }' | tr -d \") -i $(PRIVATE_KEY) $(EXTRA_SSH_COMMAND) $(DOMAIN)

--poweron: $(PRIVATE_KEY)
	@gcloud compute instances start $(shell cat $(INVENTORY) | grep -A 3 "$(HOSTANSI):var" | tail -1 | awk -F\= '{ print $$2 }')

--poweroff: $(PRIVATE_KEY) $(ENVIVARS)
	@ssh -l $(shell cat $(INVENTORY) | grep -A 1 "$(HOSTANSI):var" | tail -1 | awk -F\= '{ print $$2 }') -i $(PRIVATE_KEY) $(EXTRA_SSH_COMMAND) $(shell cat $(INVENTORY) | grep -A 2 "$(HOSTANSI):var" | tail -1 | awk -F\= '{ print $$2 }') sudo shutdown -P +1

--check_vault_file: $(VAULT_ANSIBLE)/credentials.txt $(VAULT_ANSIBLE)/env_vars.sh
	@bash -c 'if [ ! -s $(VAULT_ANSIBLE)/credentials.txt ]; then echo "Please create the $(VAULT_ANSIBLE)/credentials.txt file with the password inside"; fi;'
	@bash -c 'if [ ! -s $(VAULT_ANSIBLE)/env_vars.sh ]; then echo "Please create and complete the $(VAULT_ANSIBLE)/env_vars_ovh.sh file with correct values inside"; fi;'

--terraform_init: $(ENVIVARS)
	@stat -c "%n %U %G %A %s" $(ENVIDIR)/main.tf
	@stat -c "%n %U %G %A %s" $(ENVIDIR)/variables.tf
	@stat -c "%n %U %G %A %s" $(ENVIDIR)/outputs.tf
	@stat -c "%n %U %G %A %s" $(ENVIDIR)/backend.tf
	@echo "$(TERRAFORM_BIN) init -reconfigure -var-file=$(ENVIVARS) $(ENVIDIR)"
	@$(TERRAFORM_BIN) init -reconfigure -var-file=$(ENVIVARS) $(ENVIDIR)


--upload: 
	@git add .
	@git commit -m "$(MESSAGE)"
	@git push

--download:
	@git checkout -- .
	@git pull --rebase

--removeTerraform:
	@sudo rm -f $(TERRAFORM_BIN)

--cleanFedora:
	@sudo dnf remove wget.x86_64 unzip.x86_64 python3-fabric.noarch ansible.noarch -y

--cleanUbuntu:
	@sudo apt remove wget unzip fabric ansible -y

--cloud_bootstrap:
ifneq ($(shell gcloud auth list --format='value(ACCOUNT)' | wc -l),0)
	@gcloud auth revoke --all --quiet
endif
	@echo "Please authenticate in the correct project of GCP"
	@gcloud auth login
	@./custom-setup-sa.sh -o sudano.net -u manager@sudano.net -n terraform -b 01361D-FFCBF9-1720CD -s storage-helper-sudano-net
	@mv terraform-base-sudano-net.json $(VAULT_TERRAFORM)

--setEnviVar:
ifeq ($(ENVI),)
	$(error ENVI is not set)
else ifeq ($(ENVI),OVH)
	$(eval ENVIDIR := $(OVHDIR))
	$(eval ENVIVARS := $(OVHVARS))
	$(eval HOSTANSI := ovh)
else ifeq ($(ENVI),GCP)
	$(eval ENVIDIR := $(GCPDIR))
	$(eval ENVIVARS := $(GCPVARS))
	$(eval HOSTANSI := google)
else ifeq ($(ENVI),AWS)
	$(eval ENVIDIR := $(AWSDIR))
	$(eval ENVIVARS := $(AWSVARS))
	$(eval HOSTANSI := aws)
else ifeq ($(ENVI),ARM)
	$(eval ENVIDIR := $(ARMDIR))
	$(eval ENVIVARS := $(ARMVARS))
	$(eval HOSTANSI := arm)
else ifeq ($(ENVI),DO)
	$(eval ENVIDIR := $(DODIR))
	$(eval ENVIVARS := $(DOVARS))
	$(eval HOSTANSI := do)
else ifeq ($(ENVI),VMW)
	$(eval ENVIDIR := $(VMWDIR))
	$(eval ENVIVARS := $(VMWVARS))
	$(eval HOSTANSI := vmw)
endif

.PHONY = $(PHONY)
