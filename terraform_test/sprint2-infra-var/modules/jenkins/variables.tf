variable "ec2_associate_public_ip_address" {
  description = "Associate a public IP address with an instance in a VPC"
  type        = bool
  default     = true
}

variable "ami" {
  description = "AMI to use for the instance"
  type        = string
  default = "ami-005f9685cb30f234b"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default = "t2.micro"
}

variable "key_name" {
  description = "Key pair to use for the instance"
  type        = string
  default = "my_key_pair"
}

variable "ec2_environment" {
  description = "Environment for the EC2 instance"
  type        = string
  default = "dev"
}

variable "monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = false
}

variable "public_subnets" {
  description = "Public subnet ID"
  type        = string
}

variable "default_security_group_id" {
  description = "Security group ID"
  type        = string
}