output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web_server[*].public_ip
}

output "web_server_instance_ids" {
  description = "ID of the WEB SERVER EC2 instance"
  value       = aws_instance.web_server[*].id
}

output "bastion_host_instance_id" {
  description = "ID of the Bastion Host EC2 instance"
  value       = aws_instance.bastion_host[*].id
}

output "bastion_host_public_ip" {
  description = "Public IP of the Bastion Host EC2 instance"
  value       = aws_instance.bastion_host[*].public_ip
}

output "db_endpoint" {
  value       = aws_db_instance.db_instance.address
  description = "The endpoint of the RDS database"
}
