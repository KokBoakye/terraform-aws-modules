output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.bastion.public_ip
}

output "instance_id" {
  description = "Instance ID of the EC2 instance"
  value       = aws_instance.private_server.id
}

output "private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.private_server.private_ip
}