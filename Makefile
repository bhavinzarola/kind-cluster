.PHONY: init apply destroy

init:
	terraform init -input=false

apply: init
	terraform apply -input=false -auto-approve

destroy: init
	terraform destroy -input=false -auto-approve
