output "ec2_id" {
  description = "EC2 instance ID"
  value       = aws_instance.app.id
}

output "ec2_public_ip" {
  description = "Public IP of EC2"
  value       = aws_instance.app.public_ip
}

