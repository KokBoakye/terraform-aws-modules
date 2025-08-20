variable "user" {
  description = "The user to create the access key for"
  type        = string
}

variable "aws_region" {
    description = "Region where resources will be deployed"
    type = string
}

variable "public_subnet_cidr_block" {
    description = "Cidr block for public subnet"
    type = string
}

variable "private_subnet_cidr_block" {
    description = "Cidr block for private subnet"
    type = list(string)
}

variable "vpc_cidr_block" {
    description = "Cidr block for vpc"
    type = string
}

variable "environment" {
    description = "working environment"
    type = string
}

variable "instance_ami" {
    description = "ami of ec2 instance"
    type = string
}

variable "instance_type" {
    description = "type of ec2 instance"
    type = list(string)
}

variable "key_name" {
    description = "key pair"
    type = string
  
}

variable "app_port" {
    description = "port for application"
    type = number
}