variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of AZs to use"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
}

variable "single_nat_gateway" {
  type        = bool
  default     = false
  description = "Use single shared NAT gateway"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name for tagging"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags for all resources"
}
