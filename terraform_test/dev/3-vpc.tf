module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "dev-eks-vpc"
  cidr = "40.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", ]
  private_subnets = ["40.0.1.0/24", "40.0.2.0/24", ]
  public_subnets  = ["40.0.101.0/24", "40.0.102.0/24", ]

  create_igw         = true
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform     = "true"
    "Environment" = var.environment
  }
}