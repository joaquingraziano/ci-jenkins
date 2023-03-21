## VPC
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

variable "vpc_create_igw" {
  description = "Create Internet Gateway for the VPC"
  type        = bool
}


## EC2 Instance
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





## AWS profile and region
variable "aws_profile" {
  description = "AWS profile to use"
  type        = string
}

variable "aws_region" {
  description = "AWS region to use"
  type        = string
}



