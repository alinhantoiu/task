output "private_key" {
  value     = tls_private_key.ubuntu.private_key_pem
  sensitive = true
}
