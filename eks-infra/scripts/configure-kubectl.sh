#!/bin/bash
set -euo pipefail

CLUSTER_NAME=${1:? "Usage: ./configure-kubectl.sh <cluster-name>"}
REGION=${2:-us-east-1}

echo "🔧 Configuring kubectl for $CLUSTER_NAME ($REGION)"

aws eks --region $REGION update-kubeconfig --name $CLUSTER_NAME

echo "✅ kubectl configured!"
echo "📋 Verify:"
kubectl get nodes
kubectl get namespaces
