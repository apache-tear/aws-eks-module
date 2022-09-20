variable "cluster_name" {
  type        = string
  description = "EKS cluster name."
}

variable "namespaces" {
  type        = list(string)
  description = "List of namespaces to be created in our EKS Cluster."
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

resource "kubernetes_namespace" "eks_namespaces" {
  for_each = toset(var.namespaces)

  metadata {
    annotations = {
      name = each.key
    }
    name = each.key
  }
}