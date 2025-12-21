#!/bin/bash
set -euo pipefail

ENVIRONMENT=${1:-production}
REGION=${2:-us-east-1}

echo "💥 Destroying EKS cluster: $ENVIRONMENT"

read -p "⚠️  Type 'DESTROY' to confirm: " CONFIRM
[[ "$CONFIRM" != "DESTROY" ]] && echo "❌ Aborted" && exit 1

# 1. Delete ArgoCD apps first
kubectl delete -f ../gitops/argocd/applications/ --ignore-not-found=true
kubectl delete -k ../gitops/argocd/projects/ --ignore-not-found=true

# 2. Uninstall Helm releases
helmfile -f ../helm-releases/ destroy

# 3. Delete custom resources
kubectl delete -k ../kubernetes/base/ --ignore-not-found=true
kubectl delete -k ../security/ --ignore-not-found=true

# 4. Terraform destroy
cd ../terraform/environments/$ENVIRONMENT
terraform init
terraform destroy -auto-approve

echo "✅ Cluster destroyed!"
