#!/bin/bash
set -euo pipefail

ENVIRONMENT=${1:-production}

echo "📦 Installing Helm charts for $ENVIRONMENT"

# Export Terraform outputs
export EKS_CLUSTER_NAME=$(cd ../terraform/environments/$ENVIRONMENT && terraform output -raw cluster_name)
export AWS_REGION=us-east-1

# 1. Monitoring stack
echo "📊 Installing monitoring..."
helmfile -f helm-releases/monitoring/ apply

# 2. Applications
echo "🚀 Installing applications..."
helmfile -f helm-releases/applications/ apply

# 3. Verify deployments
echo "✅ Verifying deployments..."
kubectl get pods -n production
kubectl get ingress -n production
kubectl get svc -n monitoring

echo "✅ All Helm charts deployed!"
