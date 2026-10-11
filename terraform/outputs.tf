output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "private_key_pem" {
  description = "Private key file contents to SSH into the instance"
  value       = tls_private_key.rsa_key.private_key_pem
  sensitive   = true
}

output "monitoring_public_ip" {
  description = "Public IP address of monitoring ec2"
  value       = aws_instance.monitoring.public_ip
}

output "monitoring_privat_ip" {
  description = "Pvt of the monitoring ec2"
  value       = aws_instance.monitoring.private_ip
}
