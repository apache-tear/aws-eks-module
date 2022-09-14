resource "aws_eip" "nat_gw" {
  vpc = true

  tags = {
    Name = "${var.cluster_name}-nat-eip"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>3.14"

  name = "${var.name_prefix}-vpc"
  cidr = var.vpc_cidr

  private_subnets = tolist([
    for i in range(3) :
      cidrsubnet(var.vpc_cidr, var.subnet_prefix, i)
  ])

  public_subnets = tolist([
    for i in range(3) :
      cidrsubnet(var.vpc_cidr, var.subnet_prefix, i + var.net_offset)
  ])

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames   = true
  reuse_nat_ips          = true
  external_nat_ip_ids    = [aws_eip.nat_gw.id]

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}
