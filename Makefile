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
	@sudo apt install python3-fabric.noarch ansible -y
--i386:
	@wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TFVER}/terraform_${TFVER}_linux_386.zip
--x86-64:
	@wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TFVER}/terraform_${TFVER}_linux_amd64.zip

--requirements: ansible/requirements.yml
	@ansible-galaxy install -r ansible/requirements.yml -p ansible/roles/ --force

--vault: --check_vault_file $(VAULT_CREDENTIALS) 

--check_vault_file: $(VAULT_CREDENTIALS)
	@bash -c 'if [ ! -s $(VAULT_CREDENTIALS) ]; then echo "Please create the $(VAULT_CREDENTIALS) file with the password inside"; fi;'

upload: ## Encrypt vault files and add, commit the files with message, for ex. upload-"Add files"
	@ansible-vault encrypt ansible/vault/*.yml
	@git add .
	@git commit -m "$(MESSAGE)"
	@git push

download: ## Sync repository downloading the files and decrypt cault files for editing
	@git pull --rebase
	@ansible-vault decrypt ansible/vault/*.yml

ansible-run: $(INVENTORY) ## Run all task necessary for the correct functionality
	ansible-playbook -i $(INVENTORY) ansible/root.yml --diff $(RUN_ARGS) -l $*

ansible-check: $(INVENTORY) ## Verify all task for in the servers but not apply configuration
	ansible-playbook -i $(INVENTORY) ansible/root.yml --diff --check $(RUN_ARGS) -l $*

clean: --clean$(OS) ## Clean the project, !!WARNING¡¡ all data storage in roles folder be removed
	@rm -f /tmp/terraform*
	@sudo rm -f /usr/bin/terraform
	@rm -fR ansible/roles/*

--cleanFedora:
	@sudo dnf remove python3-fabric.noarch ansible.noarch -y
--cleanUbuntu:
	@sudo apt remove python3-fabric.noarch ansible.noarch -y

.PHONY = $(PHONY)
