.PHONY: apply destroy

ifeq ($(OS),Windows_NT)
AWS_HOME := $(subst \,/,$(USERPROFILE))
else
AWS_HOME := $(HOME)
endif

export AWS_PROFILE := default
export AWS_SDK_LOAD_CONFIG := 1
export AWS_SHARED_CREDENTIALS_FILE := $(AWS_HOME)/.aws/credentials
export AWS_CONFIG_FILE := $(AWS_HOME)/.aws/config

VAR_FILE := terraform.tfvars
VAR_ARGS := $(if $(wildcard $(VAR_FILE)),-var-file=$(VAR_FILE),)

apply:
	terraform init -input=false
	terraform apply -input=false -auto-approve $(VAR_ARGS)

destroy:
	terraform init -input=false
	terraform destroy -input=false -auto-approve $(VAR_ARGS)
