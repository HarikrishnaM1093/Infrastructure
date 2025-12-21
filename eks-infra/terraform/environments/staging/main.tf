terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

locals {
  cluster_name = "eks-prod-${random_string.suffix.result}"
  tags         = merge(var.tags, { Environment = "production" })
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source = "../../modules/vpc"

  vpc_name             = "${locals.cluster_name}-vpc"
  vpc_cidr             = var.vpc_cidr
  availability_zones   = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnet_cidrs = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  public_subnet_cidrs  = ["10.0.101.0/24","10.0.102.0/24","10.0.103.0/24"]
  single_nat_gateway   = false
  cluster_name         = locals.cluster_name
  tags                 = locals.tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name    = locals.cluster_name
  cluster_version = "1.32"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  node_groups = {
    general = {
      name           = "general-ng"
      instance_types = ["t3.medium"]
      min_size       = 2
      max_size       = 6
      desired_size   = 3
      disk_size      = 50
      labels = {
        role        = "general"
        environment = "production"
      }
      tags = {
        NodeGroup = "general"
      }
    }
  }

  tags = locals.tags
}

data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

module "eks_addons" {
  source = "../../modules/eks-addons"

  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  region            = var.region

  external_dns_hosted_zone_arns = [] # fill with ARNs if using Route53
  tags                          = locals.tags
}

module "security" {
  source = "../../modules/security"

  vpc_id       = module.vpc.vpc_id
  cluster_name = module.eks.cluster_name
  tags         = locals.tags
}
