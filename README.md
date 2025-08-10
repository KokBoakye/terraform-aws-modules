# terraform-aws-modules

This repository contains reusable Terraform modules for provisioning AWS infrastructure, including VPC, EC2 instances, and Security Groups. It follows best practices for modular infrastructure as code and supports multi-environment deployments.

---

## Modules

### 1. VPC Module
Creates a VPC with public and private subnets distributed across multiple Availability Zones (AZs), Internet Gateway, NAT Gateways, and route tables.

- Configurable for multiple environments and AZs
- Supports automatic subnet CIDR assignment
- Outputs VPC ID, subnet IDs, NAT EIP addresses, etc.

### 2. EC2 Module
Deploys EC2 instances into existing subnets.

- References VPC and subnet IDs from the VPC module
- Supports flexible instance types and counts
- Configurable security groups attachment

### 3. Security Group Module
Manages Security Groups for fine-grained network access control.

- Allows defining ingress and egress rules
- Can be attached to EC2 instances or other resources

---

## Usage

You can use these modules independently or together by referencing them in a root Terraform configuration.

### Example: Using the VPC module

```hcl
module "vpc" {
  source = "./modules/vpc"

  environment            = ["dev", "prod"]
  user                   = "kwabena"
  vpc_cidr_block         = "10.0.0.0/16"
  subnet_cidr_block      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.101.0/24", "10.0.102.0/24"]
  private_subnet_cidr_block = ["10.0.10.0/24", "10.0.20.0/24", "10.0.110.0/24", "10.0.120.0/24"]
  availability_zones     = ["eu-north-1a", "eu-north-1b"]
}

#Versioning and CI/CD
This repository uses a GitHub Actions workflow to automate version bumping and release tagging on main branch pushes.
The version is stored in a VERSION file at the root
On each push, the patch version is incremented automatically
Tags and GitHub releases are created based on the new version


#Prerequisites
Terraform 1.x
AWS CLI configured with appropriate credentials
GitHub repository with GitHub Actions enabled and proper permissions for workflow


#How to run
- Clone this repository
- Customize your root module with appropriate variables and module references
- Run Terraform commands in your root directory:
terraform init
terraform plan
terraform apply