output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "API endpoint of the cluster"
  value       = module.eks.cluster_endpoint
}

output "cluster_arn" {
  description = "Cluster ARN"
  value       = module.eks.cluster_arn
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN"
  value       = module.eks.oidc_provider_arn
}
