# k8s-standard
Raising k8s cluster in AWS using Terraform EKS module.

2 stage build:

1. Creating VPC, EKS cluster.
2. Configuring cluster: creating roles, ingress and external DNS.