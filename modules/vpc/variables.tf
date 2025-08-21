variable "vpc_cidr_block" {
    description = "CIDR block for the VPC"
    type = string

}

variable "public_subnet_cidr_block" {
    description = "CIDR block for the subnets"
    type = string
    
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

# variable "alb_sg" {
#     description = "Security group for the instances"
#     type = string
    
  
# }

# variable "instance_id" {
#     description = "Instance ID for the instances"
#     type = string
   
# }