variable "dns_domain" {
  type        = string
  description = "DNS Zone for Ingress."
}

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


data "aws_route53_zone" "base_domain" {
  name = var.dns_domain
}


resource "aws_acm_certificate" "eks_domain_cert" {
  domain_name               = var.dns_domain
  subject_alternative_names = ["*.${var.dns_domain}"]
  validation_method         = "DNS"

  tags = {
    Name = "${var.dns_domain}"
  }
}

resource "aws_route53_record" "validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.eks_domain_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.base_domain.zone_id
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.eks_domain_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation_record : record.fqdn]
}

# deploy Ingress Controller
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
