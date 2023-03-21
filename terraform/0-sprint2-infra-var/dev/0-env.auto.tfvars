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

#EKS Cluster
enable_cluster_endpoint_public_access = true
enable_cluster_endpoint_private_access = true
cluster_name = "dev-eks-cluster"
cluster_version = "1.24"
#EKS Managed Node Group 
node_group_name = "dev-eks-node-group"
node_group_instance_types = ["t3.small"]
node_group_desired_capacity = 1
node_group_min_capacity = 1
node_group_max_capacity = 3
node_group_disk_size = 20
