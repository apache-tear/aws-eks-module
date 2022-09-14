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

resource "helm_release" "external_dns" {
  name       = var.ext_dns_chart
  chart      = var.ext_dns_chart
  repository = var.ext_dns_repo
  version    = var.ext_dns_chart_ver
  namespace  = "kube-system"

  dynamic "set" {
    for_each = var.ext_dns_values

    content {
      name  = set.key
      value = set.value
      type  = "string"
    }
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.ext_dns_role}"
  }

  set {
    name  = "domainFilters"
    value = "{${var.dns_domain}}"
  }

  set {
    name  = "txtOwnerId"
    value = data.aws_route53_zone.base_domain.zone_id
  }
}
