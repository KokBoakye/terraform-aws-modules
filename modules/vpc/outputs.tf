output "vpc_id" {
    description = "The ID of the VPC"
    value = aws_vpc.master_vpc.id
}

output "eip" {
    description = "EIPs for NAT Gateways"
    value = aws_eip.nat_eip[*].public_ip
}

output "private_subnet_ids" {
    description = "List of private subnet IDs"
    value = aws_subnet.private_subnet[*].id
}

output "public_subnet_ids" {
    description = "List of public subnet IDs"
    value = aws_subnet.public_subnet[*].id
}
