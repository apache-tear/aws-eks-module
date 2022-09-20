variable "ingress_gw_name" {
  type        = string
  description = "Load-balancer service name."
}

variable "ingress_gw_role" {
  type        = string
  description = "IAM Role associated with load-balancer service."
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


resource "kubernetes_service_account" "load_balancer_controller" {
  metadata {
    name      = var.ingress_gw_name
    namespace = "kube-system"

    labels = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name"      = var.ingress_gw_name
    }

    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.ingress_gw_role}"
    }
  }
}

resource "helm_release" "ingress_gateway" {
  name       = var.ingress_gw_chart
  chart      = var.ingress_gw_chart
  repository = var.ingress_gw_repo
  version    = var.ingress_gw_chart_ver
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.load_balancer_controller.metadata.0.name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }
}
