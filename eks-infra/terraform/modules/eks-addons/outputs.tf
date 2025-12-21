output "alb_irsa_role_arn" {
  description = "IRSA role ARN for AWS Load Balancer Controller"
  value       = module.aws_load_balancer_controller_irsa.iam_role_arn
}

output "cluster_autoscaler_irsa_role_arn" {
  description = "IRSA role ARN for Cluster Autoscaler"
  value       = module.cluster_autoscaler_irsa.iam_role_arn
}

output "external_dns_irsa_role_arn" {
  description = "IRSA role ARN for External DNS"
  value       = module.external_dns_irsa.iam_role_arn
}
