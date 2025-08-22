

output "app_sg_id" {
  description = "ID of the app security group"
  value       = aws_security_group.app_sg.id
}

output "alb_sg_id" {
  description = "ID of the alb security group"
  value       = aws_security_group.alb_sg.id
}

output "bastion_sg_id" {
  description = "ID of the bastion security group"
  value       = aws_security_group.bastion_sg.id

}