#!/bin/bash
set -euo pipefail

ENVIRONMENT=${1:-production}
REGION=${2:-us-east-1}

echo "🚀 Setting up EKS cluster: $ENVIRONMENT ($REGION)"

# 1. Terraform Infra
echo "📦 Deploying infrastructure..."
cd ../terraform/environments/$ENVIRONMENT
terraform init -upgrade
terraform plan -out=tfplan
terraform apply tfplan

CLUSTER_NAME=$(terraform output -raw cluster_name)
echo "✅ Cluster created: $CLUSTER_NAME"

# 2. Configure kubectl
echo "🔧 Configuring kubectl..."
aws eks --region $REGION update-kubeconfig --name $CLUSTER_NAME

# 3. Wait for nodes
echo "⏳ Waiting for nodes..."
kubectl wait --for=condition=Ready nodes --all --timeout=600s

# 4. Base Kubernetes resources
echo "🏗️  Applying base resources..."
kubectl apply -k ../../kubernetes/base/

# 5. Infrastructure Helm charts (ALB, ExternalDNS, etc.)
echo "⚙️  Installing infrastructure..."
cd ../..
helmfile -f helm-releases/infrastructure/ apply

echo "✅ Cluster setup complete!"
echo "📊 Cluster: $CLUSTER_NAME"
echo "🔗 kubectl configured for: $REGION"
