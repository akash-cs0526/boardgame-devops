output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "private_key_pem" {
  description = "Private key file contents to SSH into the instance"
  value       = tls_private_key.rsa_key.private_key_pem
  sensitive   = true
}
