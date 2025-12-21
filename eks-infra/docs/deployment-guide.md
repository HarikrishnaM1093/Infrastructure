# 🚀 Deployment Guide

## Prerequisites
AWS CLI + Terraform
aws configure set region us-east-1
terraform version >= 1.3

kubectl + helm
kubectl version --client
helm version >= 3.12

S3 bucket for TF state
aws s3 mb s3://your-tf-state-bucket --region us-east-1
aws dynamodb create-table
--table-name terraform-locks
--attribute-definitions AttributeName=LockID,AttributeType=S
--key-schema AttributeName=LockID,KeyType=HASH
--provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
--region us-east-1

text

## 1️⃣ Infrastructure (5-10 min)
cd terraform/environments/production
terraform init
terraform apply -auto-approve
aws eks update-kubeconfig --name $(terraform output -raw cluster_name)

text

## 2️⃣ Base Kubernetes
kubectl apply -k kubernetes/base/
kubectl apply -k security/

text

## 3️⃣ Infrastructure Addons
helmfile -f helm-releases/infrastructure/ apply

text

## 4️⃣ Monitoring + Apps
helmfile -f helm-releases/monitoring/ apply
helmfile -f helm-releases/applications/ apply

text

## 5️⃣ GitOps (Recommended)
make -C gitops argocd-install

Visit ArgoCD UI: localhost:8080
text

## 🔍 Verify Deployment
Cluster healthy?
kubectl get nodes
kubectl top nodes

App accessible?
kubectl get ingress -n production
curl -I $(kubectl get ingress -n production -o jsonpath='{.items.status.loadBalancer.ingress.hostname}')

Monitoring?
kubectl port-forward svc/prometheus-stack-grafana -n monitoring 3000:80

text

## 🎯 Access Points
| Service | URL/Port |
|---------|----------|
| Application | `http://<ALB-DNS>/` |
| Grafana | `http://grafana.example.com` |
| ArgoCD | `make -C gitops argocd-ui` |
| Datadog | `datadoghq.com` |

## 🧹 Cleanup
make destroy ENV=production

text
undefined
