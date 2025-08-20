variable "region" {
    description = "aws region"
    type = string
    

}

variable "vpc_id" {
    description = "VPC ID where the security group will be created"
    type = string
    
}

variable "app_port" {
    description = "Application port for backend (for App SG)"
    type = number
    
}