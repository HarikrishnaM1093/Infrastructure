variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "cluster_name" {
  type        = string
}

variable "tags" {
  type        = map(string)
  default     = {}
}
