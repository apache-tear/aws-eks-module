autoscaling_average_cpu = 50

eks_managed_node_groups = {
  "x86-group" = {
    ami_type     = "AL2_x86_64"
    min_size     = 1
    max_size     = 5
    desired_size = 1
    capacity_type = ["ON_DEMAND"]
    instance_types = [
      "t3.small",
      "t3a.small",
      "t3a.medium",
    ]
    network_interfaces = [{
      delete_on_termination       = true
      associate_public_ip_address = true
    }]
  }
}
