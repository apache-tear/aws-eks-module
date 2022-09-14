variable "eks_managed_node_groups" {
  type        = map(any)
  description = "EKS managed node groups."
}

variable "autoscaling_average_cpu" {
  type        = number
  description = "Average CPU threshold for EKS EC2 autoscaling."
}