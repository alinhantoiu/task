output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = (aws_subnet.private_subnets[*].id)
}

  value = element(random_shuffle.subnets.result, 0)