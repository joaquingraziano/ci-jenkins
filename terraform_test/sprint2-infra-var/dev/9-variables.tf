variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_azs" {
  description = "Availability zones for the VPC"
  type        = list(string)
}

variable "vpc_private_subnets" {
  description = "Private subnets for the VPC"
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "Public subnets for the VPC"
  type        = list(string)
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT Gateway for the VPC"
  type        = bool
}

variable "environment" {
  description = "Environment for the VPC"
  type        = string
}

variable "vpc_enable_single_nat_gateway" {
  description = "Enable single NAT Gateway for the VPC"
  type        = bool
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  description = "Enable DNS hostnames for the VPC"
  type        = bool
  default     = true
}








variable "ec2_associate_public_ip_address" {
  description = "Associate a public IP address with an instance in a VPC"
  type        = bool
}

variable "ami" {
  description = "AMI to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair to use for the instance"
  type        = string
}

variable "ec2_environment" {
  description = "Environment for the EC2 instance"
  type        = string
}

variable "monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
}




variable "enable_cluster_endpoint_public_access" {
  description = "Enable cluster endpoint"
  type        = bool
}

variable "enable_cluster_endpoint_private_access" {
  description = "Enable cluster endpoint"
  type        = bool
}

variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "cluster_version" {
  description = "Version of the cluster"
  type        = string
}

## node group
variable "node_group_name" {
  description = "Name of the node group"
  type        = string
}

variable "node_group_instance_types" {
  description = "Instance types of the node group"
  type        = list(string)
}

variable "node_group_desired_capacity" {
  description = "Desired capacity of the node group"
  type        = number
}

variable "node_group_min_capacity" {
  description = "Min capacity of the node group"
  type        = number
}

variable "node_group_max_capacity" {
  description = "Max capacity of the node group"
  type        = number
}

variable "node_group_disk_size" {
  description = "Disk size of the node group"
  type        = number
}

