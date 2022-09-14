variable "cluster_name" {
  type        = string
  description = "EKS cluster name."
}

variable "env_tag" {
  type        = string
  description = "Tag for an environment name."
}

variable "name_prefix" {
  type        = string
  description = "Prefix for an AWS object name."
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block."
}

variable "subnet_prefix" {
  type        = number
  description = "CIDR block bits extension for subnets."
}

variable "net_offset" {
  type        = number
  description = "CIDR offset for Public subnets."
}

variable "eks_managed_node_groups" {
  type        = map(any)
  description = "Map of EKS managed node group."
}

variable "autoscaling_average_cpu" {
  type        = number
  description = "Average CPU threshold to autoscale EKS EC2 instances."
}

variable "dns_domain" {
  type        = string
  description = "DNS Zone name to be used from EKS Ingress."
}

variable "ingress_gw_name" {
  type        = string
  description = "Load-balancer service name."
}

variable "ingress_gw_role" {
  type        = string
  description = "IAM Role Name associated with load-balancer service."
}

variable "ingress_gw_chart" {
  type        = string
  description = "Ingress Gateway Helm chart name."
}

variable "ingress_gw_repo" {
  type        = string
  description = "Ingress Gateway Helm repository name."
}

variable "ingress_gw_chart_ver" {
  type        = string
  description = "Ingress Gateway Helm chart version."
}

variable "ext_dns_role" {
  type        = string
  description = "IAM Role Name associated with external-dns service."
}

variable "ext_dns_chart" {
  type        = string
  description = "Chart Name associated with external-dns service."
}

variable "ext_dns_repo" {
  type        = string
  description = "Chart Repo associated with external-dns service."
}

variable "ext_dns_chart_ver" {
  type        = string
  description = "Chart Repo associated with external-dns service."
}

variable "ext_dns_values" {
  type        = map(string)
  description = "Values map required by external-dns service."
}

variable "namespaces" {
  type        = list(string)
  description = "List of namespaces to be created in our EKS Cluster."
}

variable "adm_users" {
  type        = list(string)
  description = "List of Kubernetes admins."
}

variable "dev_users" {
  type        = list(string)
  description = "List of Kubernetes developers."
}
