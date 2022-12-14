ext_dns_role      = "external-dns"
ext_dns_chart     = "external-dns"
ext_dns_repo      = "https://kubernetes-sigs.github.io/external-dns/"
ext_dns_chart_ver = "1.11.0"

ext_dns_values = {
  "image.repository"   = "k8s.gcr.io/external-dns/external-dns",
  "image.tag"          = "v1.11.0", #0.11
  "logLevel"           = "info",
  "logFormat"          = "json",
  "triggerLoopOnEvent" = "true",
  "interval"           = "5m",
  "policy"             = "sync",
  "sources"            = "{ingress}"
}

dns_domain           = "a-sh.ae"

ingress_gw_name      = "aws-load-balancer-controller"
ingress_gw_role      = "load-balancer-controller"
ingress_gw_chart     = "aws-load-balancer-controller"
ingress_gw_repo      = "https://aws.github.io/eks-charts"
ingress_gw_chart_ver = "2.4.3" #1.4.1
