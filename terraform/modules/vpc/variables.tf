# variables.tf
# module vpc variables
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
}

variable "vpc_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
}

variable "vpc_enable_nat_gateway" {
  description = "Whether to create NAT Gateways for the VPC"
  type        = bool
}

variable "vpc_single_nat_gateway" {
  description = "Whether to create a single NAT Gateway for the VPC"
  type        = bool
}

variable "environment" {
  description = "The environment the VPC is being created in"
  type        = string
  default = "dev"
}


