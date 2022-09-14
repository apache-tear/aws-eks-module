resource "aws_security_group" "eks" {
    name   = "${var.name_prefix}-sg-eks"

    ingress {
      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
      from_port                     = 9443
      to_port                       = 9443
      protocol                      = "tcp"
      source_cluster_security_group = true
    }
    
    ingress {
      description              = "Allow connections from ALB SG"
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"
      source_security_group_id = aws_security_group.alb.id
    }
    
    ingress {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      self      = true
    }

    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
}
  