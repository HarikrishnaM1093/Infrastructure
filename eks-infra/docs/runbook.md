# 📋 Runbook - Incident Response

## P0: Cluster Unreachable
Check EKS status: aws eks describe-cluster --name <cluster>

Node health: kubectl get nodes

Control plane SGs: AWS Console → EKS → Networking

VPC CNI: kubectl logs -n kube-system daemonset/aws-node

text

## P1: Pods Not Scheduling
kubectl describe pod <pod> -n production

Node taints: kubectl get nodes -o yaml | grep taint

Cluster autoscaler: kubectl logs -n kube-system deployment/cluster-autoscaler

Resource quotas: kubectl describe namespace production

text

## P2: Application 5xx Errors
kubectl logs deployment/nginx-app -n production --tail=50

ALB target health: AWS Console → EC2 → Target Groups

NetworkPolicy: kubectl describe networkpolicy -n production

Service endpoints: kubectl get endpoints nginx-app -n production

text

## P3: High CPU/Memory
kubectl top pods -n production

Datadog: kubernetes_statefulset_replica_missing

Prometheus: http://prometheus:9090/graph → CPU queries

Node exporter: kubectl top nodes

text

## Backup/Restore
Backup
velero backup create daily-backup --include-namespaces=production --schedule="0 2 * * *"

Restore
velero restore create --from-backup daily-backup-YYYYMMDD

text

## Rollout Commands
Safe rollout
kubectl rollout restart deployment/nginx-app -n production

Verify
kubectl rollout status deployment/nginx-app -n production

History
kubectl rollout history deployment/nginx-app -n production

text
undefined