# EKS Infrastructure

Minimal production-ready Amazon EKS setup using Terraform, Helm, and Kubernetes manifests.

Features:
- VPC + subnets
- EKS cluster with managed node groups
- IRSA for addons
- AWS Load Balancer Controller
- ExternalDNS
- Cluster Autoscaler
- Sample application via Helm with ALB Ingress

## Quick start

cd terraform/environments/production
terraform init
terraform apply -auto-approve

Configure kubectl
aws eks --region us-east-1 update-kubeconfig --name $(terraform output -raw cluster_name)

Apply base K8s resources
kubectl apply -k ../../kubernetes/base

Deploy application
helm upgrade --install app ../..//helm-charts/application
-n production --create-namespace
-f ../../helm-charts/application/values-production.yaml

text
undefined