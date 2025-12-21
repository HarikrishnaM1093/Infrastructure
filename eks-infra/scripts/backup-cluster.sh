#!/bin/bash
set -euo pipefail

ENVIRONMENT=${1:-production}
BUCKET="eks-backups-$ENVIRONMENT-$(date +%Y%m%d)"

echo "💾 Creating cluster backup: $ENVIRONMENT"

# 1. Install Velero (if not present)
helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts
helm repo update

helm upgrade --install velero vmware-tanzu/velero \
  --namespace velero --create-namespace \
  --set configuration.provider=aws \
  --set configuration.backupStorageLocation.bucket=$BUCKET \
  --set configuration.backupStorageLocation.config.region=us-east-1 \
  --set credentials.existingSecret=velero-creds

# 2. Create backup
velero backup create "full-cluster-$(date +%Y%m%d-%H%M)" \
  --include-namespaces=* \
  --wait

echo "✅ Backup complete: full-cluster-$(date +%Y%m%d-%H%M)"
echo "📦 S3: s3://$BUCKET"
