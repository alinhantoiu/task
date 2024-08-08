output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_key" {
  value     = module.ec2.private_key
  sensitive = true
}