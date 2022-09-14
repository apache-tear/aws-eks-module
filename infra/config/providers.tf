terraform {
  required_version = "~>1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.30"
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
