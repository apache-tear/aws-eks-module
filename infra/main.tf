module "create" {
  source = "./create/"

  cluster_name            = var.cluster_name
  name_prefix             = var.name_prefix
  vpc_cidr                = var.vpc_cidr
  subnet_prefix           = var.subnet_prefix
  net_offset              = var.net_offset
  eks_managed_node_groups = var.eks_managed_node_groups
  autoscaling_average_cpu = var.autoscaling_average_cpu
}

module "config" {
  source = "./config/"

  cluster_name         = module.create.cluster_id
  dns_domain           = var.dns_domain
  ingress_gw_name      = var.ingress_gw_name
  ingress_gw_role      = var.ingress_gw_role
  ingress_gw_chart     = var.ingress_gw_chart
  ingress_gw_repo      = var.ingress_gw_repo
  ingress_gw_chart_ver = var.ingress_gw_chart_ver
  ext_dns_role         = var.ext_dns_role
  ext_dns_chart        = var.ext_dns_chart
  ext_dns_repo         = var.ext_dns_repo
  ext_dns_chart_ver    = var.ext_dns_chart_ver
  ext_dns_values       = var.ext_dns_values
  namespaces           = var.namespaces
  name_prefix          = var.name_prefix
  adm_users            = var.adm_users
  dev_users            = var.dev_users
}
