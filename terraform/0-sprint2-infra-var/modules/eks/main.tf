module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "dev-eks-webdemo"
  cluster_version = "1.24"

  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  eks_managed_node_groups = {
    node-group = {
      name             = "node-group"
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = ["t3.small"]
      disk_size        = 20
      subnets          = module.vpc.private_subnets
      tags = {
        "Environment" = var.environment
      }
    }
  }
  tags = {
    Terraform     = "true"
    "Environment" = var.environment
  }
}

resource "aws_security_group_rule" "dev-eks_ingress_http" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.eks.cluster_security_group_id
}