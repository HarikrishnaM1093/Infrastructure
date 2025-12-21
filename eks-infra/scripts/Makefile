.PHONY: cluster-setup helm-install argocd-install backup destroy

ENV ?= production
CLUSTER_NAME ?= $(shell cd ../terraform/environments/$(ENV) && terraform output -raw cluster_name 2>/dev/null || echo "")

cluster-setup:
	./scripts/setup-cluster.sh $(ENV)

helm-install:
	./scripts/install-helm-charts.sh $(ENV)

argocd-install:
	./scripts/deploy-argocd.sh $(ENV)

backup:
	./scripts/backup-cluster.sh $(ENV)

destroy:
	./scripts/destroy-cluster.sh $(ENV)

configure-kubectl:
	./scripts/configure-kubectl.sh $(CLUSTER_NAME)
