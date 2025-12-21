# 🌐 EKS Infrastructure as Code

**Production-ready EKS cluster** with GitOps, monitoring, security, and CI/CD.

[![Terraform](https://img.shields.io/badge/terraform-~%3E1.3-blue.svg)](https://www.terraform.io/)
[![ArgoCD](https://img.shields.io/badge/gitops-argocd-green.svg)](https://argoproj.github.io/cd/)
[![Datadog](https://img.shields.io/badge/monitoring-datadog-brightgreen.svg)](https://www.datadoghq.com/)

## Quick Start (~15 min)
make cluster-setup ENV=production # EKS + infra
make helm-install ENV=production # Apps + monitoring
make -C gitops argocd-install # GitOps 🎯

text

## Features
- ✅ **Multi-env**: dev/staging/production
- ✅ **Infrastructure**: ALB, ExternalDNS, Autoscaler
- ✅ **Monitoring**: Datadog + Prometheus + Grafana + Loki
- ✅ **GitOps**: ArgoCD app-of-apps pattern
- ✅ **Security**: NetworkPolicy + OPA + PodSecurity + IRSA
- ✅ **CI/CD**: GitHub Actions + GitLab + Jenkins
- ✅ **Backups**: Velero to S3

## Architecture
![Architecture](./docs/diagrams/architecture.png)

See [docs/deployment-guide.md](docs/deployment-guide.md)

## License
MIT