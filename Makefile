SHELL = /bin/bash

VAULT_CREDENTIALS = ansible/vault/credentials.txt
INVENTORY = ansible/inventory
BASE_TERRAFORM = terraform/environments/
OS = $(shell hostnamectl | grep "Operating System:" | awk -F\  '{ print $$3 }')
ARCH = $(shell hostnamectl | grep "Architecture:" | awk -F\  '{ print $$2 }')
TFVER = 0.12.0

#-------------------------------------------------------#
#    Public Functions                                   #
#-------------------------------------------------------#
PHONY += help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort | awk 'BEGIN {FS = ":.*?## "}; \
	{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

PHONY += bootstrap 
bootstrap: --dependencies --vault --requirements ## Prepare of environment and the security for the deploy

PHONY += upload
upload: encrypt --upload decrypt ## Encrypt vault files and add, commit the files with message, for e.g. upload MESSAGE="Add files"

PHONY += download
download: --download decrypt ## Downloading the files and decrypt vault files for editing ¡¡WARNING!! this operation remove all changes without commiting

encrypt: ## Encrypt files for uploading to repository
	@ansible-vault encrypt ansible/vault/*.yml
	@ansible-vault encrypt terraform/vault/*.tfvars

decrypt: ## Decrypt files for working with them
	@ansible-vault decrypt ansible/vault/*.yml
	@ansible-vault decrypt terraform/vault/*.tfvars

ansible-run: $(INVENTORY) ## Run all task necessary for the correct functionality
	ansible-playbook -i $(INVENTORY) ansible/root.yml --diff $(RUN_ARGS) -l $*

ansible-check: $(INVENTORY) ## Verify all task for in the servers but not apply configuration
	ansible-playbook -i $(INVENTORY) ansible/root.yml --diff --check $(RUN_ARGS) -l $*

devdeploy: vault/terraform.tfvars $(BASE_TERRAFORM)/02-dev/main.tf $(BASE_TERRAFORM)/02-dev/variables.tf $(BASE_TERRAFORM)/02-dev/outputs.tf
	terraform plan -var-file="../../vault/terraform.tfvars"

soft_clean: ## Clean the project, this only remove all Roles and temporary files, use with careful
	@rm -fR ansible/roles/*
	@rm -f /tmp/terraform*

PHONY += hard_clean
hard_clean: soft_clean --removeTerraform --clean$(OS) ## Clean the project, !!WARNING¡¡ all data storage in roles folder be removed, and the programs using deleted too!!!

#-------------------------------------------------------#
#    Private Functions                                  #
#-------------------------------------------------------#
--dependencies: --$(OS) --$(ARCH)
	@unzip -q -o -d /tmp /tmp/terraform.zip
	@sudo mv /tmp/terraform /usr/bin/
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

--vault: --check_vault_file $(VAULT_CREDENTIALS)
	@ansible-vault decrypt ansible/vault/*.yml
	@ansible-vault decrypt terraform/vault/*.tfvars

--check_vault_file:
	@bash -c 'if [ ! -s $(VAULT_CREDENTIALS) ]; then echo "Please create the $(VAULT_CREDENTIALS) file with the password inside"; fi;'

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
