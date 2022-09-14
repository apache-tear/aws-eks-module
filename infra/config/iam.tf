variable "name_prefix" {
  type        = string
  description = "Prefix for object Names."
}

variable "adm_users" {
  type        = list(string)
  description = "List of k8s admins."
}

variable "dev_users" {
  type        = list(string)
  description = "List of k8s devs."
}

# Admins & Devs user maps
locals {
  adm_user_map = [
    for admin_user in var.adm_users :
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${admin_user}"
      username = admin_user
      groups   = ["system:masters"]
    }
  ]

  dev_user_map = [
    for dev_user in var.dev_users :
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${dev_user}"
      username = dev_user
      groups   = ["${var.name_prefix}-devs"]
    }
  ]
}

# add 'mapUsers' section to 'aws-auth' configmap with Admins & Developers
resource "time_sleep" "wait" {
  create_duration = "180s"
  triggers = {
    cluster_endpoint = data.aws_eks_cluster.cluster.endpoint
  }
}

resource "kubernetes_config_map_v1_data" "aws_auth_users" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = yamlencode(concat(local.adm_user_map, local.dev_user_map))
  }

  force = true
  depends_on = [time_sleep.wait]
}

# Create dev Role using RBAC
resource "kubernetes_cluster_role" "iam_roles_developers" {
  metadata {
    name = "${var.name_prefix}-devs"
  }

  rule {
    api_groups = ["*"]
    resources  = ["pods", "pods/log", "deployments", "ingresses", "services"]
    verbs      = ["get", "list"]
  }

  rule {
    api_groups = ["*"]
    resources  = ["pods/exec"]
    verbs      = ["create"]
  }

  rule {
    api_groups = ["*"]
    resources  = ["pods/portforward"]
    verbs      = ["*"]
  }
}

# bind developer Users with their Role
resource "kubernetes_cluster_role_binding" "iam_roles_developers" {
  metadata {
    name = "${var.name_prefix}-devs"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "${var.name_prefix}-devs"
  }

  dynamic "subject" {
    for_each = toset(var.dev_users)

    content {
      name      = subject.key
      kind      = "User"
      api_group = "rbac.authorization.k8s.io"
    }
  }
}
