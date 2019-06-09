SHELL = /bin/bash

VAULT_CREDENTIALS = ansible/vault/credentials.txt
INVENTORY = ansible/inventory
OS = $(shell hostnamectl | grep "Operating System:" | awk -F\  '{ print $$3 }')
ARCH = $(shell hostnamectl | grep "Architecture:" | awk -F\  '{ print $$2 }')
TFVER = 0.12.0

PHONY += help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort | awk 'BEGIN {FS = ":.*?## "}; \
	{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

PHONY += bootstrap 
bootstrap: --dependencies --vault --requirements ## Prepare of environment and the security for the deploy

--dependencies: --$(OS) --$(ARCH)
	@unzip -q -o -d /tmp /tmp/terraform.zip
	@sudo mv /tmp/terraform /usr/bin/
--Fedora:
	@sudo dnf install python3-fabric.noarch ansible.noarch -y
--Ubuntu:
	@sudo apt update -y
	@sudo apt install unzip fabric ansible -y
--i386:
	@wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TFVER}/terraform_${TFVER}_linux_386.zip
--x86-64:
	@wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TFVER}/terraform_${TFVER}_linux_amd64.zip

--requirements: ansible/requirements.yml
	@ansible-galaxy install -r ansible/requirements.yml -p ansible/roles/ --force

--vault: --check_vault_file $(VAULT_CREDENTIALS)
	@ansible-vault decrypt ansible/vault/*.yml

--check_vault_file:
	@bash -c 'if [ ! -s $(VAULT_CREDENTIALS) ]; then echo "Please create the $(VAULT_CREDENTIALS) file with the password inside"; fi;'

PHONY += upload
upload: encrypt --upload decrypt ## Encrypt vault files and add, commit the files with message, for e.g. upload MESSAGE="Add files"

PHONY += download
download: --download decrypt ## Sync repository downloading the files and decrypt cault files for editing

--upload: 
	@git add .
	@git commit -m "$(MESSAGE)"
	@git push

--download:
	@git pull --rebase

encrypt: ## Encrypt files for uploading to repository
	@ansible-vault encrypt ansible/vault/*.yml

decrypt: ## Decrypt files for working with them
	@ansible-vault decrypt ansible/vault/*.yml

ansible-run: $(INVENTORY) ## Run all task necessary for the correct functionality
	ansible-playbook -i $(INVENTORY) ansible/root.yml --diff $(RUN_ARGS) -l $*

ansible-check: $(INVENTORY) ## Verify all task for in the servers but not apply configuration
	ansible-playbook -i $(INVENTORY) ansible/root.yml --diff --check $(RUN_ARGS) -l $*

PHONY += clean
clean: --clean$(OS) --removefiles ## Clean the project, !!WARNING¡¡ all data storage in roles folder be removed

--removefiles:
	@rm -f /tmp/terraform*
	@sudo rm -f /usr/bin/terraform
	@rm -fR ansible/roles/*
--cleanFedora:
	@sudo dnf remove python3-fabric.noarch ansible.noarch -y
--cleanUbuntu:
	@sudo apt remove python3-fabric.noarch ansible.noarch -y

.PHONY = $(PHONY)