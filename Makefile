SHELL = /bin/bash

VAULT_ANSIBLE = ansible/vault
INVENTORY = ansible/inventory
BASE_TERRAFORM = terraform/environments
TERRAFORM_DIRS = $(wildcard $(BASE_TERRAFORM)/*)
TFVARS_FILES = $(wildcard $(BASE_TERRAFORM)/*/*.tfvars)
PRIVATE_KEY = ~/.ssh/id_rsa_deploying
EXTRA_SSH_COMMAND = -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
OS = $(shell hostnamectl | grep "Operating System:" | awk -F\  '{ print $$3 }')
ARCH = $(shell hostnamectl | grep "Architecture:" | awk -F\  '{ print $$2 }')
TERRAFORM_BIN = $(shell which terraform)
TFVER = $(shell $(TERRAFORM_BIN) --version | head -1 | tr -d 'Terraform v')

define PRINT

ifeq ($(1),INFO)
	@echo -e "\033[33m[$(1)]\033[34m $(2)\033[39m"
else ifeq ($(1),ERROR)
	@echo -e "\033[31m[$(1)]\033[34m $(2)\033[39m"
else ifeq ($(1),HELP)
	@echo -e "\033[32m[$(1)]\033[34m $(2)\033[39m"
else
	@echo -e "\033[32m$(1)\033[39m"
endif

endef

#-------------------------------------------------------#
#    Public Functions                                   #
#-------------------------------------------------------#
.PHONY: help
help: ## Makefile Self-Documented, help target is the same that you view here
	@echo -e "Some of the follow options it's permmit for ENVI var: "
	@echo -e "\t- OVH deploy OVH server"
	@echo -e "\t- GCP deploy Google server"
	@echo -e "\t- DO deploy Digital Ocean server"
	@echo -e "\t- AWS deploy Amazon server"
	@echo -e "\t- ARM deploy Azure server"
	@echo -e "\t- VMW deploy VmWare Workstation server"
	@echo
	@echo -e "Example commands:"
	@echo -e "\t- make deploy_check"
	@echo -e "\t- make ansible_run EXTRA=\"-t mariadb -vvv\""
	@echo
	@echo -e "Useful commands:"
	@echo -e "\t- Make a backup of production server: make ansible_check EXTRA=\"-l ovh -t backup\""
	@echo -e "\t- Update a production server: make ansible_check EXTRA=\"-t ovh -t update\""
	@echo
	@grep -oE '^[a-zA-Z0-9_-]+:.*?## .*$$|*+[%0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}{printf "\033[36m%-30s\033[39m %s\n", $$1, $$2}' \
	| sort -u

.PHONY: all
all:
ifeq ($(VER),BETA)
	$(eval TERRAFORM_BIN := /usr/bin/terraform-beta)
	$(eval TFVER := 1.1.0-rc1)
endif
	@echo -e "\033[33m[INFO]\033[34m Bin: $(TERRAFORM_BIN)\033[39m"
	@echo -e "\033[33m[INFO]\033[34m TFVer: $(TFVER)\033[39m"

define GENTARGETS

$(eval TARGET = $(subst /,-,$(subst terraform/environments/,,$(DIR))))

$(addprefix .tf-init-,$(TARGET)):
	$(call PRINT,INFO,We're initializing the $(TARGET) environment)
	source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(DIR) init -reconfigure

.PHONY: $(addprefix tf-init-,$(TARGET))
$(addprefix tf-init-,$(TARGET)):tf-init-%: all .tf-init-$(TARGET) ## We can Initializate the environment and prepare environment for deploy automatically

$(addprefix .tf-plan-,$(TARGET)):
	source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(DIR) plan

.PHONY: $(addprefix tf-plan-,$(TARGET))
$(addprefix tf-plan-,$(TARGET)):tf-plan-%: all .tf-plan-$(TARGET) ## Check the modify of deploy the new infrastructure for environment to setting in ENVI var 

$(addprefix .tf-apply-,$(TARGET)):
	source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(DIR) apply -auto-approve 

.PHONY: $(addprefix tf-apply-,$(TARGET))
$(addprefix tf-apply-,$(TARGET)):tf-apply-%: all .tf-apply-$(TARGET) ## Deploy new infrastructure for environment to setting in ENVI var

$(addprefix .tf-destroy-,$(TARGET)):
	source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(DIR) destroy

.PHONY: $(addprefix tf-destroy-,$(TARGET))
$(addprefix tf-destroy-,$(TARGET)):tf-destroy-%: all .tf-destroy-$(TARGET) ## Un-Deploy all infrestructure the environment of develop

$(addprefix .tf-show-,$(TARGET)):
	source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(DIR) show

.PHONY: $(addprefix tf-show-,$(TARGET))
$(addprefix tf-show-,$(TARGET)):tf-show-%: all .tf-show-$(TARGET) ## Show the status of deploy with descriptions of the resources

$(addprefix .tf-output-,$(TARGET)):
	source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(DIR) output

.PHONY: $(addprefix tf-output-,$(TARGET))
$(addprefix tf-output-,$(TARGET)):tf-output-%: all .tf-output-$(TARGET) ## Show the output that exist in the deployments

$(addprefix .tf-provider-,$(TARGET)):
	$(call PRINT,INFO,Following you will see the list of providers in $(TARGET) environment)
	source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(DIR) providers

.PHONY: $(addprefix tf-provider-,$(TARGET))
$(addprefix tf-provider-,$(TARGET)):tf-provider-%: all .tf-provider-$(TARGET) ## Show the providers that exist in the folders

$(addprefix .tf-list-resources-,$(TARGET)):
	source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(DIR) show | grep "#"

.PHONY: $(addprefix tf-list-resources-,$(TARGET))
$(addprefix tf-list-resources-,$(TARGET)):tf-list-resources-%: all .tf-list-resources-$(TARGET) ## List resources that were deploy, simple view to delete one of them

$(addprefix .tf-remove-resource-,$(TARGET)):
ifeq ($(RESOURCE),)
	@echo "Error: RESOURCE is not set, please select the resource to destroy from the terraform_list_resources "
else
	source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(DIR) destroy -target=$(RESOURCE)
endif

.PHONY: $(addprefix tf-remove-resource-,$(TARGET))
$(addprefix tf-remove-resource-,$(TARGET)):tf-remove-resource-%: all .tf-remove-resource-$(TARGET) ## Remove one resource of the list, user the follow var to set RESOURCE="resource to destroy"

$(addprefix .tf-create-graph-,$(TARGET)):
	source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(DIR) graph | dot -Tsvg > environment.svg

.PHONY: $(addprefix tf-create-graph-,$(TARGET))
$(addprefix tf-create-graph-,$(TARGET)):tf-create-graph-%: all .tf-create-graph-$(TARGET) ## Generate a graph of the environment structure

$(addprefix .tf-check-format-,$(TARGET)):
	source $(VAULT_ANSIBLE)/env_vars.sh; $(TERRAFORM_BIN) -chdir=$(DIR) graph | dot -Tsvg > environment.svg

.PHONY: $(addprefix tf-check-format-,$(TARGET))
$(addprefix tf-check-format-,$(TARGET)):tf-check-format-%: all .tf-check-format-$(TARGET) ## Check if the Terraform format is fine

endef

# $(info $(foreach DIR, $(TERRAFORM_DIRS), $(call GENTARGETS)))
$(foreach DIR, $(TERRAFORM_DIRS), $(eval $(call GENTARGETS)))

.PHONY: install-beta
install-beta: all .$(OS) .$(ARCH) ## Prepare of environment and install programs needed for deploying, you need set VER=BETA to install
ifeq ($(VER),BETA)
	@unzip -q -o -d /tmp /tmp/terraform.zip
	@sudo mv /tmp/terraform $(TERRAFORM_BIN)
endif

.PHONY: cloud_prerequisites
cloud_prerequisites: all .decrypt .cloud_bootstrap .encrypt ## Prepare project of Google to deploy de infrastructure

ansible_check: ansible/root.yml .requirements ## Verify all task for in the servers but not apply configuration, extra vars supported EXTRA="-l ovh -t backup -vvv"
	@echo "ansible-playbook ansible/root.yml --diff --check --vault-password-file $(VAULT_ANSIBLE)/credentials.txt --inventory ansible/inventory $(EXTRA)"
	@ansible-playbook ansible/root.yml --diff --check --vault-password-file $(VAULT_ANSIBLE)/credentials.txt --inventory ansible/inventory $(EXTRA)

ansible_run: ansible/root.yml .requirements ## Run all task necessary for the correct functionality, extra vars supported EXTRA="-l ovh -t backup -vvv"
	@ansible-playbook ansible/root.yml --diff --vault-password-file $(VAULT_ANSIBLE)/credentials.txt --inventory ansible/inventory $(EXTRA)

.PHONY: upload
upload: encrypt .upload ## Encrypt vault files and add, commit the files with message, for e.g. upload MESSAGE="Add files"

.PHONY: download
download: .download decrypt ## Downloading the files and decrypt vault files for editing ¡¡WARNING!! this operation remove all changes without commiting

.PHONY: connect
connect: decrypt .connect encrypt ## Connect to the remote instance with the key for deployment

#.PHONY: 17_poweron
#17_poweron: all .decrypt .setEnviVar .poweron .deploy_check .encrypt # # Power on the instance

#.PHONY: 18_poweroff
#18_poweroff: .decrypt .setEnviVar .poweroff .encrypt # # Power off the instance

.PHONY: encrypt
encrypt: .encrypt-all ## Encrypt files for uploading to repository

.PHONY: decrypt
decrypt: .decrypt-all ## Decrypt files for working with them

.PHONY: soft_clean
soft_clean: ## Clean the project, this only remove all Roles and temporary files, use with careful
	@rm -fR ansible/roles/*
	@rm -f /tmp/terraform*
	@rm -f terraform.log
	@rm -f environment.svg
	@rm -fR ./*.backup
	@find . -name .terraform* -exec rm -fR {} \;

.PHONY: hard_clean
hard_clean: soft_clean .removeTerraform --clean$(OS) ## Clean the project, !!WARNING¡¡ all data storage in roles folder be removed, and the programs using deleted too!!!

#-------------------------------------------------------#
#    Private Functions                                  #
#-------------------------------------------------------#
.Fedora:
	@sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	@sudo bash -c 'echo -e \
"[azure-cli]\n\
name=Azure CLI\n\
baseurl=https://packages.microsoft.com/yumrepos/azure-cli\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
	@sudo dnf install -y google-cloud-sdk azure-cli wget.x86_64 unzip.x86_64 python3-fabric.noarch python3-dnf.noarch ansible.noarch

.Ubuntu:
	@sudo apt update -y
	@sudo apt install -y google-cloud-sdk wget unzip fabric ansible

.Manjaro:
	@sudo pacman -Syu --noconfirm community/yay
	@yay
	@yay -Syu --noconfirm community/jq extra/wget extra/graphviz extra/unzip fabric ansible terraform # aur/google-cloud-sdk

.i386:
	@wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TFVER}/terraform_${TFVER}_linux_386.zip

.x86-64:
	@wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TFVER}/terraform_${TFVER}_linux_amd64.zip

.requirements: ansible/requirements.yml
	@ansible-galaxy role install -r ansible/requirements.yml -p ansible/roles/ --force
	@ansible-galaxy collection install -r ansible/requirements.yml --force

.connect: $(PRIVATE_KEY) $(ENVIVARS)
	@ssh -l $(shell cat $(ENVIVARS) | grep "ssh_user" | awk -F\  '{ print $$3 }' | tr -d \") -i $(PRIVATE_KEY) $(EXTRA_SSH_COMMAND) $(DOMAIN)

# .poweron: $(PRIVATE_KEY)
# 	@gcloud compute instances start $(shell cat $(INVENTORY) | grep -A 3 "$(HOSTANSI):var" | tail -1 | awk -F\= '{ print $$2 }')

# .poweroff: $(PRIVATE_KEY) $(ENVIVARS)
# 	@ssh -l $(shell cat $(INVENTORY) | grep -A 1 "$(HOSTANSI):var" | tail -1 | awk -F\= '{ print $$2 }') -i $(PRIVATE_KEY) $(EXTRA_SSH_COMMAND) $(shell cat $(INVENTORY) | grep -A 2 "$(HOSTANSI):var" | tail -1 | awk -F\= '{ print $$2 }') sudo shutdown -P +1

.encrypt-all:
	@ansible-vault encrypt $(TFVARS_FILES) > /dev/null
	@ansible-vault encrypt $(VAULT_ANSIBLE)/*.sh > /dev/null
	@ansible-vault encrypt $(VAULT_ANSIBLE)/*.ini > /dev/null
	@ansible-vault encrypt $(VAULT_ANSIBLE)/.ovhapi > /dev/null
	@ansible-vault encrypt ansible/group_vars/all/vault > /dev/null

.decrypt-all:
	@ansible-vault decrypt $(TFVARS_FILES) > /dev/null
	@ansible-vault decrypt $(VAULT_ANSIBLE)/*.sh > /dev/null
	@ansible-vault decrypt $(VAULT_ANSIBLE)/*.ini > /dev/null
	@ansible-vault decrypt $(VAULT_ANSIBLE)/.ovhapi > /dev/null
	@ansible-vault decrypt ansible/group_vars/all/vault > /dev/null

.check_vault_file: $(VAULT_ANSIBLE)/credentials.txt $(VAULT_ANSIBLE)/env_vars.sh
	@bash -c 'if [ ! -s $(VAULT_ANSIBLE)/credentials.txt ]; then echo "Please create the $(VAULT_ANSIBLE)/credentials.txt file with the password inside"; fi;'
	@bash -c 'if [ ! -s $(VAULT_ANSIBLE)/env_vars.sh ]; then echo "Please create and complete the $(VAULT_ANSIBLE)/env_vars_ovh.sh file with correct values inside"; fi;'

.upload: 
	@git add .
	@git commit -m "$(MESSAGE)"
	@git push

.download:
	@git checkout -- .
	@git pull --rebase

.removeTerraform:
	@sudo rm -f $(TERRAFORM_BIN)

.cleanFedora:
	@sudo dnf remove wget.x86_64 unzip.x86_64 python3-fabric.noarch ansible.noarch -y

.cleanUbuntu:
	@sudo apt remove wget unzip fabric ansible -y

.cloud_bootstrap:
ifneq ($(shell gcloud auth list --format='value(ACCOUNT)' | wc -l),0)
	@gcloud auth revoke --all --quiet
endif
	@echo "Please authenticate in the correct project of GCP"
	@gcloud auth login
	@./custom-setup-sa.sh -o sudano.net -u manager@sudano.net -n terraform -b 01361D-FFCBF9-1720CD -s storage-helper-sudano-net
	@mv terraform-base-sudano-net.json $(VAULT_TERRAFORM)

.DEFAULT_GOAL: help