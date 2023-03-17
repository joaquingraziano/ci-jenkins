#VPC
vpc_name                 = "dev-eks-vpc"
vpc_cidr                 = "10.0.0.0/16"
vpc_azs                  = ["us-east-1a", "us-east-1b"]
vpc_private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
vpc_public_subnets       = ["10.0.101.0/24", "10.0.102.0/24"]
vpc_enable_nat_gateway   = true
vpc_enable_dns_hostnames = true
vpc_enable_single_nat_gateway = true
environment              = "dev"

#EC2 Jenkins
ami = "ami-0557a15b87f6559cf"
instance_type = "t2.micro"
key_name = "my_key_pair"
ec2_associate_public_ip_address = true
monitoring = false
ec2_environment = "dev"