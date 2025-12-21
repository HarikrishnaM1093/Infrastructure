variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "cluster_version" {
  type        = string
  default     = "1.32"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs"
}

variable "cluster_endpoint_public_access" {
  type    = bool
  default = true
}

variable "cluster_endpoint_private_access" {
  type    = bool
  default = true
}

variable "node_groups" {
  description = "Map of EKS managed node groups"
  type        = any
  default     = {}
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags"
}
