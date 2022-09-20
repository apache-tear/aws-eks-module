variable "dns_domain" {
  type        = string
  description = "DNS Zone for Ingress."
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