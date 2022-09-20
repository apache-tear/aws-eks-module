variable "cluster_name" {
  type        = string
  description = "EKS cluster name."
}

variable "name_prefix" {
  type        = string
  description = "Prefix for AWS object names."
}

variable "vpc_cidr" {
  type        = string
  description = "Base VPC CIDR block."
}

variable "subnet_prefix" {
  type        = number
  description = "CIDR block bits extension for subnets."
}

variable "net_offset" {
  type        = number
  description = "CIDR offset for public subnets."
}

variable "eks_managed_node_groups" {
  type        = map(any)
  description = "EKS managed node groups."
}

variable "autoscaling_average_cpu" {
  type        = number
  description = "Average CPU threshold for EKS EC2 autoscaling."
}