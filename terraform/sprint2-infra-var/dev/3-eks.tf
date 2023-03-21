module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version

  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  cluster_endpoint_private_access = var.enable_cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.enable_cluster_endpoint_public_access
  
  eks_managed_node_groups = {
    node-group = {
      name             = var.node_group_name
      desired_capacity = var.node_group_desired_capacity
      max_capacity     = var.node_group_max_capacity
      min_capacity     = var.node_group_min_capacity
      instance_types   = var.node_group_instance_types
      disk_size        = var.node_group_disk_size
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