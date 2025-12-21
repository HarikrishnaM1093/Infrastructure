.PHONY: init plan apply destroy kubeconfig

ENV ?= production
REGION ?= us-east-1

init:
	cd terraform/environments/$(ENV) && terraform init

plan:
	cd terraform/environments/$(ENV) && terraform plan

apply:
	cd terraform/environments/$(ENV) && terraform apply -auto-approve

destroy:
	cd terraform/environments/$(ENV) && terraform destroy -auto-approve

kubeconfig:
	aws eks --region $(REGION) update-kubeconfig --name $$(cd terraform/environments/$(ENV) && terraform output -raw cluster_name)
