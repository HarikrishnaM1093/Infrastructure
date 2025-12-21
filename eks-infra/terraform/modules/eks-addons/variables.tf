variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC provider ARN from EKS"
}

variable "region" {
  type        = string
  description = "AWS region"
}

# AWS Load Balancer Controller
variable "alb_controller_version" {
  type        = string
  default     = "1.8.0"
  description = "Helm chart version for AWS Load Balancer Controller"
}

variable "alb_namespace" {
  type        = string
  default     = "kube-system"
}

variable "alb_chart_repository" {
  type        = string
  default     = "https://aws.github.io/eks-charts"
}

variable "alb_chart_name" {
  type        = string
  default     = "aws-load-balancer-controller"
}

# Cluster Autoscaler
variable "cluster_autoscaler_version" {
  type        = string
  default     = "9.10.0"
}

variable "cluster_autoscaler_namespace" {
  type        = string
  default     = "kube-system"
}

variable "cluster_autoscaler_chart_repository" {
  type        = string
  # GitHub Pages has been flaky; consider vendoring chart if issues occur [web:47][web:59]
  default     = "https://raw.githubusercontent.com/kubernetes/autoscaler/master/charts"
}

variable "cluster_autoscaler_chart_name" {
  type        = string
  default     = "cluster-autoscaler"
}

# External DNS
variable "external_dns_version" {
  type        = string
  default     = "1.14.3"
}

variable "external_dns_namespace" {
  type        = string
  default     = "kube-system"
}

variable "external_dns_chart_repository" {
  type        = string
  default     = "https://kubernetes-sigs.github.io/external-dns/"
}

variable "external_dns_chart_name" {
  type        = string
  default     = "external-dns"
}

variable "external_dns_hosted_zone_arns" {
  type        = list(string)
  default     = []
  description = "Route53 hosted zone ARNs that ExternalDNS may manage"
}

variable "tags" {
  type        = map(string)
  default     = {}
}
