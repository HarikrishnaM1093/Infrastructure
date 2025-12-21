# 🔧 Troubleshooting

## Common Issues

### Terraform
❌ Error: cluster not found
→ aws eks update-kubeconfig --name <cluster-name>

❌ Error: no identity found
→ Update AWS credentials/role permissions

text

### Helm/Applications
❌ Pods CrashLoopBackOff
kubectl logs deployment/nginx-app -n production

❌ Ingress pending
→ Check AWS Load Balancer Controller logs:
kubectl logs -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller

❌ No external IP on LoadBalancer
→ ALB controller not installed:
helmfile -f helm-releases/infrastructure/aws-load-balancer-controller.yaml

text

### ArgoCD
❌ App stuck "Progressing"
→ Check ArgoCD events:
kubectl describe application <app-name> -n argocd

❌ Sync failed
→ Repo URL wrong in app-of-apps.yaml
→ Update gitops/argocd/applications/app-of-apps.yaml

text

### Monitoring
❌ Prometheus 404
→ Port-forward:
kubectl port-forward svc/prometheus-stack-kube-prom-p-kube-prom-prometheus -n monitoring 9090

❌ Grafana empty
→ Sidecar datasources:
kubectl get configmap -n monitoring grafana-datasources

text

## kubectl Debug Commands
All-in-one status
kubectl get nodes,pods,svc,ingress --all-namespaces

Events (last 1h)
kubectl get events --sort-by='.lastTimestamp' --field-selector involvedObject.namespace=production

Resource usage
kubectl top nodes,pods -n production

ALB controller logs
kubectl logs -n kube-system deployment/aws-load-balancer-controller -f

text

## AWS Console Links
EKS: https://console.aws.amazon.com/eks/home
Load Balancers: https://console.aws.amazon.com/ec2/v2/home#LoadBalancers:
Route53: https://console.aws.amazon.com/route53/home
CloudWatch: https://console.aws.amazon.com/cloudwatch/home

text

## Reset to Clean State
make destroy ENV=production
rm -rf terraform/environments/production/.terraform/
terraform init

text
undefined