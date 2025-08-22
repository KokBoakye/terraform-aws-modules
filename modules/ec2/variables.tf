variable "aws_region" {
    description = "AWS region"
    type = string
   
}

variable "instance_type" {
    description = "Instance type of EC2 instances"
    type = list(string)
    
}

variable "vpc_id" {
    description = "VPC ID where the instances will be launched"
    type = string
    
}

variable "private_subnet_ids" {
    description = "Private Subnet ID where the application/data base instances will be launched"
    type = list(string)
    
}

variable "public_subnet_ids" {
    description = "Public Subnet ID where the web servers will be launched"
    type = list(string)
    
}



variable "environment" {
    description = "Environment for the instances"
    type = string
    
}

variable "user" {
    description = "User for the instances"
    type = string
    
}

variable "key_name" {
    description = "Key name for the instances"
    type = string
    
}



variable "app_sg" {
    description = "Security group for the instances"
    type = string
    
  
}

variable "bastion_sg" {
    description = "Security group for the instances"
    type = string
    
}