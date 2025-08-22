variable "vpc_cidr_block" {
    description = "CIDR block for the VPC"
    type = string

}

variable "public_subnet_cidr_block" {
    description = "CIDR block for the subnets"
    type = list(string)
    
}

variable "private_subnet_cidr_block" {
    description = "CIDR block for the subnets"
    type = list(string)
    
}


variable "aws_region" {
    description = "Region for AWS resources"
    type = string
    
}


variable "user" {
    description = "User for the AWS resources"
    type = string
   
}

variable "environment" {
    description = "Environment for the AWS resources"
    type = string
   
}

