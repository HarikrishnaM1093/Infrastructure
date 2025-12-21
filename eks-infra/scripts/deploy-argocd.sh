#!/bin/bash
set -euo pipefail

ENVIRONMENT=${1:-production}

echo "🎯 Deploying ArgoCD GitOps for $ENVIRONMENT"

# 1. Install ArgoCD
kubectl create namespace argocd || true
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 2. Wait for ArgoCD
kubectl wait --for=condition=Available deployment/argocd-server -n argocd --timeout=300s

# 3. Apply projects
kubectl apply -k ../gitops/argocd/projects/

# 4. Deploy app-of-apps (watches repo changes)
kubectl apply -f ../gitops/argocd/applications/app-of-apps.yaml

# 5. Get login info
echo "✅ ArgoCD deployed!"
echo "🔐 Admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo "🌐 UI: make -C ../gitops argocd-ui"
