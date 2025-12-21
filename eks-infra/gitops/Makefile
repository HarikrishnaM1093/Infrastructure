.PHONY: argocd-install argocd-apps flux-install deploy-all

# Install ArgoCD + all apps
argocd-install:
	kubectl create namespace argocd || true
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl apply -k gitops/argocd/projects
	kubectl apply -f gitops/argocd/applications/app-of-apps.yaml

# Port-forward ArgoCD UI
argocd-ui:
	kubectl port-forward svc/argocd-server -n argocd 8080:443

# Deploy everything via GitOps
deploy-all: argocd-install
	kubectl apply -k kubernetes/base
	helmfile -f helm-releases/infrastructure apply
	@echo "✅ GitOps active! Commit/push to auto-deploy"

# FluxCD bootstrap (alternative)
flux-install:
	flux bootstrap github \
	  --owner=YOUR-ORG \
	  --repository=eks-infrastructure \
	  --branch=main \
	  --path=gitops/fluxcd/clusters/production
