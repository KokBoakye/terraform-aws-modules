output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web_server[*].public_ip
}

output "instance_id" {
  description = "Instance ID of the EC2 instance"
  value       = aws_instance.private_server.id
}