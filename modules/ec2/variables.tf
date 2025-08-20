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
    type = string
    
}

variable "instance_ami" {
    description = "Ami for EC2 instances"
    type = string
    # default = {
    #     "ubuntu" = "ami-042b4708b1d05f512"
    #     "amazon_linux_2" = "ami-0b83c7f5e2823d1f4"
    #     "windows" = "ami-0b59aaac1a4f1a3d1"
    #     "macos" = "ami-037aceb0f4efe8b1a"
        
        
    # }
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

variable "security_group" {
    description = "Security group for the instances"
    type = string
    
  
}