module "external_dns_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                  = "${var.cluster_name}-external-dns"
  attach_external_dns_policy = true

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["${var.external_dns_namespace}:external-dns"]
    }
  }

  tags = var.tags
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = var.external_dns_chart_repository
  chart      = var.external_dns_chart_name
  namespace  = var.external_dns_namespace
  version    = var.external_dns_version

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "external-dns"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.external_dns_irsa.iam_role_arn
  }

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "policy"
    value = "sync"
  }

  set {
    name  = "txtOwnerId"
    value = var.cluster_name
  }
}
