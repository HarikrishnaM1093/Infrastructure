# 🏗️ Architecture Overview

## High-Level Diagram
EKS Control Plane (Managed)
├── VPC (3 AZs: public/private subnets)
│ ├── EKS Cluster (1.32)
│ │ ├── Managed Node Groups (general/app)
│ │ ├── IRSA Roles (ALB, ExternalDNS, Cluster Autoscaler, Datadog)
│ │ └── Addons (CoreDNS, VPC CNI, EBS CSI)
│ ├── AWS Load Balancer Controller → ALB Ingress
│ ├── ExternalDNS → Route53
│ └── NAT Gateway (HA)
├── ArgoCD (GitOps)
├── Monitoring (Datadog + Prometheus + Grafana + Loki)
├── Velero (Backups)
└── Security (NetworkPolicy + OPA Gatekeeper + PodSecurity)

text

## Components

### Infrastructure Layer
| Component | Purpose | Helm Chart |
|-----------|---------|------------|
| AWS ALB Controller | Ingress → ALB | `eks/aws-load-balancer-controller` |
| ExternalDNS | Ingress → Route53 | `kubernetes-sigs/external-dns` |
| Cluster Autoscaler | Pod pending → scale nodes | `kubernetes/autoscaler` |
| Cert-Manager | ACME/Let's Encrypt | `jetstack/cert-manager` |
| Datadog Agent | Metrics/Logs/Traces | `datadog/datadog` |

### Application Layer
Git (main) → ArgoCD → EKS Production
↓
nginx-app (ALB: app.example.com)
↓
api-service (internal ClusterIP)

text

### Data Flow
Git commit → ArgoCD detects → syncs helm-releases/

Helm renders → deploys nginx-app to production NS

ALB Controller → creates internet-facing ALB

ExternalDNS → creates Route53 A record

Datadog → scrapes metrics/logs → dashboards

Prometheus → alerts on CPU > 85%

text

## Network Architecture
Internet
↓ ALB (public subnets)
nginx-app → Service (ClusterIP)
↓ NetworkPolicy (allow specific)
Datadog → Promtail → Loki (logs)

text

## Security Model
- **PodSecurity**: Restricted (no root, no privileged)
- **NetworkPolicy**: Default deny + explicit allow
- **OPA Gatekeeper**: Labels required, no `:latest` tags
- **IRSA**: Least privilege IAM roles
- **RBAC**: Namespace-scoped + cluster roles