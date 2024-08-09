output "private_key" {
  value     = tls_private_key.ubuntu.private_key_pem
  sensitive = true
}

output "instance_id" {
  value = aws_instance.server.id
}