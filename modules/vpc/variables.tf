variable "vpc_cidr_block" {
    description = "CIDR block for the VPC"
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
    description = "CIDR block for the subnets"
    type = list(string)
    default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}

variable "private_subnet_cidr_block" {
    description = "CIDR block for the subnets"
    type = list(string)
    default = ["10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24", "10.0.8.0/24"]
}


variable "aws_region" {
    description = "Region for AWS resources"
    type = string
    default = "eu-north-1"
}

variable "availability_zones" {
    description = "List of availability zones for the VPC"
    type = list(string)
    default = ["eu-north-1a", "eu-north-1b"]
}

variable "user" {
    description = "User for the AWS resources"
    type = string
    default = "Kwabena" # Replace with your actual user name
}

variable "environment" {
    description = "Environment for the AWS resources"
    type = list(string)
    default = ["dev", "prod"]
}