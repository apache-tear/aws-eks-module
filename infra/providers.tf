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

  cloud {
    organization = "rocknrolldevs"

    workspaces {
      name = "k8s-standard"
    }
  }
}

provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
  
  default_tags {
    tags = {
      Environment = "Terraform"
    }
  }
}

data "aws_caller_identity" "current" {}
