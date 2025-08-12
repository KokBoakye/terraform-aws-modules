output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web_server[*].public_ip
}

output "web_server_instance_ids" {
  description = "ID of the WEB SERVER EC2 instance"
  value       = aws_instance.web_server[*].public_ip
}