variable "region" {
    description = "aws region"
    type = string
    default = "eu-north-1"

}

variable "vpc_id" {
    description = "VPC ID where the security group will be created"
    type = string
    default = "vpc-08ae8025a470920b6"
}

variable "app_port" {
    description = "Application port for backend (for App SG)"
    type = number
    default = 8080
}