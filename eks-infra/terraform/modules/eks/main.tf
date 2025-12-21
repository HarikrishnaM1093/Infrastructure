module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0" # match current docs [web:72][web:80]

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnet_ids
  control_plane_subnet_ids = var.private_subnet_ids

  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access

  enable_irsa                              = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = var.node_groups

  tags = var.tags
}
