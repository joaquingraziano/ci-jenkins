module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0.0"

  cluster_name    = "eks-webdemo"
  cluster_version = "1.24"

  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflict = "OVERWRITE"
    }

    kube-proxy = {
      resolve_conflict = "OVERWRITE"
    }

    vpc-cni = {
      resolve_conflict = "OVERWRITE"
    }
    csi = {
      resolve_conflict = "OVERWRITE"
    }
  }

  manage_aws_auth_configmap = true


  eks_managed_node_groups = {
    node-group = {
      name             = "node-group"
      desired_capacity = 1
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = ["t2.micro"]
      disk_size        = 20
      subnets          = module.vpc.private_subnets
      tags = {
        "k8s.io/cluster-autoscaler/enabled"     = "true"
        "k8s.io/cluster-autoscaler/eks-webdemo" = "owned"
        Environment                             = "dev"
      }
    }
  }
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}