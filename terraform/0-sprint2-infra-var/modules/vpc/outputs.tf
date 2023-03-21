output "public_subnets" {
  value = module.vpc.public_subnet_ids[0]
}

output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}