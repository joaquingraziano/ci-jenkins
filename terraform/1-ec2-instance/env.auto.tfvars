## VPC
vpc_name               = "dev-ec2-vpc"
vpc_cidr               = "10.0.0.0/16"
vpc_azs                = ["us-east-1a", "us-east-1b", "us-east-1c"]
vpc_private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
vpc_public_subnets     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
vpc_enable_nat_gateway = false
environment            = "dev"
vpc_create_igw         = true

## EC2 Instance
ec2_associate_public_ip_address = true
ami                             = "ami-0557a15b87f6559cf"
instance_type                   = "t3.small"
key_name                        = "my_key_pair"
ec2_environment                 = "dev"
monitoring                      = false

## Profile and Region
aws_profile = "onepanman"
aws_region  = "us-east-1"