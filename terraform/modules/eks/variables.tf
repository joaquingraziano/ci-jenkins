variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs inside the VPC"
  type        = list(string)
}

variable "environment" {
  description = "The environment the VPC is being created in"
  type        = string
  default = "dev"
}