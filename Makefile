SHELL = /bin/bash

VAULT_ANSIBLE = ansible/vault
VAULT_TERRAFORM = terraform/vault
INVENTORY = ansible/inventory
VARS_DIR = ../../vault
OVHVARS = $(VARS_DIR)/ovh.tfvars
GCPVARS = $(VARS_DIR)/gcp.tfvars
AWSVARS = $(VARS_DIR)/aws.tfvars
ARMVARS = $(VARS_DIR)/arm.tfvars
DOVARS = $(VARS_DIR)/do.tfvars
VMWVARS = $(VARS_DIR)/vmw.tfvars
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
	@echo -e "\t- make ENVI=GCP 09_ansible-run EXTRA=\"-t mariadb -vvv\""
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
	$(eval TERRAFORM_BIN := /usr/bin/terraform-beta)
else
	$(eval TFVER := 0.15.0)
	$(eval TERRAFORM_BIN := /usr/bin/terraform)
endif
	@echo -e "Ver: $(TFVER)"
	@echo -e "Bin: $(TERRAFORM_BIN)"

PHONY += prerequisites
01_prerequisites: all --$(OS) --$(ARCH) ## Prepare of environment and install programs needed for deploying
	@unzip -q -o -d /tmp /tmp/terraform.zip
	@sudo mv /tmp/terraform $(TERRAFORM_BIN)

PHONY += 02_cloud_prerequisites
02_cloud_prerequisites: all --decrypt --cloud_bootstrap --encrypt ## Prepare project of Google to deploy de infrastructure

PHONY += 03_bootstrap 
03_bootstrap: all --check_vault_file --requirements --setEnviVar --decrypt --terraform_init --encrypt ## Prepare environment for deploy automatically

PHONY += 04_deploy_check
04_deploy_check: all --decrypt --setEnviVar --deploy_check --encrypt ## Check the modify of deploy the new infrastructure for environment to setting in ENVI var 

PHONY += 05_terraform_show
05_terraform_show: all --decrypt --setEnviVar --terraform_show --encrypt ## Show the status of deploy with descriptions of the resources

PHONY += 06_terraform_output
06_terraform_output: all --decrypt --setEnviVar --terraform_outputs --encrypt ## Show the output that exist in the deployments

PHONY += 07_terraform_list_resources
07_terraform_list_resources: all --decrypt --setEnviVar --list_resources --encrypt ## List resources that were deploy, simple view to delete one of them

PHONY += 08_terraform_remove_resource
08_terraform_remove_resource: all --decrypt --setEnviVar --remove_resources --encrypt ## Remove one resource of the list, user the follow var to set RESOURCE="resource to destroy"

PHONY += 09_deploy_run
09_deploy_run: all --decrypt --setEnviVar --deploy_run --encrypt ## Deploy new infrastructure for environment to setting in ENVI var

PHONY += 10_infra_remove
10_infra_remove: all --decrypt --setEnviVar --infra_remove --encrypt  ## Un-Deploy all infrestructure the environment of develop

PHONY += 11_create_graph
11_create_graph: all --decrypt --setEnviVar --create_graph --encrypt ## Generate a graph of the environment structure

12_ansible_check: --setEnviVar ansible/root.yml ## Verify all task for in the servers but not apply configuration, extra vars supported EXTRA="-vvv"
	@echo "ansible-playbook ansible/root.yml --diff --check --vault-password-file $(VAULT_ANSIBLE)/credentials.txt --inventory ansible/inventory -l $(HOSTANSI) $(EXTRA)"
	@ansible-playbook ansible/root.yml --diff --check --vault-password-file $(VAULT_ANSIBLE)/credentials.txt --inventory ansible/inventory -l $(HOSTANSI) $(EXTRA)

13_ansible_run: --setEnviVar ansible/root.yml ## Run all task necessary for the correct functionality, extra vars supported EXTRA="-vvv"
	@ansible-playbook ansible/root.yml --diff --vault-password-file $(VAULT_ANSIBLE)/credentials.txt --inventory ansible/inventory -l $(HOSTANSI) $(EXTRA)

PHONY += 14_upload
14_upload: --encrypt --upload ## Encrypt vault files and add, commit the files with message, for e.g. upload MESSAGE="Add files"

PHONY += 15_download
15_download: --download --decrypt ## Downloading the files and decrypt vault files for editing ¡¡WARNING!! this operation remove all changes without commiting

PHONY += 16_connect
16_connect: --decrypt --connect --encrypt ## Connect to the remote instance with the key for deployment

PHONY += 17_poweron
17_poweron: all --decrypt --setEnviVar --poweron --deploy_check --encrypt ## Power on the instance

PHONY += 18_poweroff
18_poweroff: --decrypt --setEnviVar --poweroff --encrypt ## Power off the instance

PHONY += 19_encrypt
19_encrypt: --encrypt ## Encrypt files for uploading to repository

PHONY += 20_decrypt
20_decrypt: --decrypt ## Decrypt files for working with them

21_soft_clean: ## Clean the project, this only remove all Roles and temporary files, use with careful
	@rm -fR ansible/roles/*
	@rm -fR .terraform/
	@rm -f /tmp/terraform*
	@rm -f terraform.log
	@rm -f environment.svg
	@rm -fR ./*.backup

PHONY += 22_hard_clean
22_hard_clean: 21_soft_clean --removeTerraform --clean$(OS) ## Clean the project, !!WARNING¡¡ all data storage in roles folder be removed, and the programs using deleted too!!!

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

--deploy_check: --check_vault_file
	@echo "source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(ENVIDIR) plan -var-file=$(ENVIVARS)"
	@source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(ENVIDIR) plan -var-file=$(ENVIVARS)

--deploy_run: --check_vault_file
	@echo "source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(ENVIDIR) apply -auto-approve -var-file=$(ENVIVARS)"
	@source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(ENVIDIR) apply -auto-approve -var-file=$(ENVIVARS)

--infra_remove: $(ENVIVARS)
	@echo "source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(ENVIDIR) destroy -var-file=$(ENVIVARS)"
	@source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(ENVIDIR) destroy -var-file=$(ENVIVARS)

--terraform_show:
	@echo "source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(ENVIDIR) show"
	@source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(ENVIDIR) show

--terraform_outputs:
	@echo "source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(ENVIDIR) output"
	@source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(ENVIDIR) output

--list_resources:
	@echo "source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(ENVIDIR) show | grep \"#\""
	@source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(ENVIDIR) show | grep "#"

--remove_resources:
	@echo "source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(ENVIDIR) destroy -var-file=$(ENVIVARS) -target=$(RESOURCE)"
ifeq ($(RESOURCE),)
	@echo "Error: RESOURCE is not set, please select the resource to destroy from the terraform_list_resources "
else
	@source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(ENVIDIR) destroy -var-file=$(ENVIVARS) -target=$(RESOURCE)
endif

--create_graph: $(ENVIVARS)
	@$(TERRAFORM_BIN) -chdir=$(ENVIDIR) graph | dot -Tsvg > environment.svg

--connect: $(PRIVATE_KEY) $(ENVIVARS)
	@ssh -l $(shell cat $(ENVIVARS) | grep "ssh_user" | awk -F\  '{ print $$3 }' | tr -d \") -i $(PRIVATE_KEY) $(EXTRA_SSH_COMMAND) $(DOMAIN)

--poweron: $(PRIVATE_KEY)
	@gcloud compute instances start $(shell cat $(INVENTORY) | grep -A 3 "$(HOSTANSI):var" | tail -1 | awk -F\= '{ print $$2 }')

--poweroff: $(PRIVATE_KEY) $(ENVIVARS)
	@ssh -l $(shell cat $(INVENTORY) | grep -A 1 "$(HOSTANSI):var" | tail -1 | awk -F\= '{ print $$2 }') -i $(PRIVATE_KEY) $(EXTRA_SSH_COMMAND) $(shell cat $(INVENTORY) | grep -A 2 "$(HOSTANSI):var" | tail -1 | awk -F\= '{ print $$2 }') sudo shutdown -P +1

--encrypt:
	@ansible-vault encrypt $(VAULT_ANSIBLE)/*.sh > /dev/null
	@ansible-vault encrypt $(VAULT_ANSIBLE)/*.ini > /dev/null
	@ansible-vault encrypt $(VAULT_ANSIBLE)/.ovhapi > /dev/null
	@ansible-vault encrypt ansible/group_vars/all/vault > /dev/null
	@ansible-vault encrypt $(VAULT_TERRAFORM)/*.tfvars > /dev/null
	@ansible-vault encrypt $(VAULT_TERRAFORM)/*.json > /dev/null

--decrypt:
	@ansible-vault decrypt $(VAULT_ANSIBLE)/*.sh > /dev/null
	@ansible-vault decrypt $(VAULT_ANSIBLE)/*.ini > /dev/null
	@ansible-vault decrypt $(VAULT_ANSIBLE)/.ovhapi > /dev/null
	@ansible-vault decrypt ansible/group_vars/all/vault > /dev/null
	@ansible-vault decrypt $(VAULT_TERRAFORM)/*.tfvars > /dev/null
	@ansible-vault decrypt $(VAULT_TERRAFORM)/*.json > /dev/null

--check_vault_file: $(VAULT_ANSIBLE)/credentials.txt $(VAULT_ANSIBLE)/env_vars.sh
	@bash -c 'if [ ! -s $(VAULT_ANSIBLE)/credentials.txt ]; then echo "Please create the $(VAULT_ANSIBLE)/credentials.txt file with the password inside"; fi;'
	@bash -c 'if [ ! -s $(VAULT_ANSIBLE)/env_vars.sh ]; then echo "Please create and complete the $(VAULT_ANSIBLE)/env_vars_ovh.sh file with correct values inside"; fi;'

--terraform_init: $(ENVIVARS)
	@source $(VAULT_ANSIBLE)/env_vars.sh
	@stat -c "%n %U %G %A %s" $(ENVIDIR)/main.tf
	@stat -c "%n %U %G %A %s" $(ENVIDIR)/variables.tf
	@stat -c "%n %U %G %A %s" $(ENVIDIR)/outputs.tf
	@stat -c "%n %U %G %A %s" $(ENVIDIR)/backend.tf
	@echo "$(TERRAFORM_BIN) -chdir=$(ENVIDIR) init -reconfigure -var-file=$(ENVIVARS)"
	@$(TERRAFORM_BIN) -chdir=$(ENVIDIR) init -reconfigure -var-file=$(ENVIVARS)


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
