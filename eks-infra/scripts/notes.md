# Full setup (5 minutes)
make cluster-setup ENV=production

# Apps + monitoring
make helm-install ENV=production

# GitOps (commit → auto-deploy)
make argocd-install ENV=production

# Backup
make backup ENV=production

# Teardown
make destroy ENV=production
