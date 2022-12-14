terraform {
  required_version = "~>1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.13"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.6"
    }
    time = {
      source  = "hashicorp/time"
      version = "~>0.8"
    }
  }
}

data "aws_caller_identity" "current" {}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}