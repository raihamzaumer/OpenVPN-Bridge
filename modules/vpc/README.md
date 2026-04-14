# Terraform VPC Module

This Terraform module creates a **complete AWS VPC infrastructure** with industry-standard features. It supports multi-AZ deployments, public and private subnets, NAT gateway (optional), route tables, and security groups for both application and database layers.

---

## Features

- **VPC**: Creates a VPC with customizable CIDR block.
- **Subnets**: Creates public and private subnets in multiple Availability Zones.
- **Internet Gateway**: Attaches an IGW for internet access.
- **Route Tables**:
  - Public route table with routes to Internet Gateway.
  - Private route table with optional NAT Gateway for outbound internet.
- **Elastic IP**: Optional EIP for NAT Gateway.
- **NAT Gateway**: Optional NAT for private subnets.
- **Security Groups**:
  - App Security Group (public access, customizable ingress rules)
  - Database Security Group (private access, allows only app SG)
- **Tagging**: All resources are tagged using the VPC name prefix.

---

## Usage

```hcl
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr           = "10.0.0.0/16"
  vpc_name           = "prod-vpc"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
  anywhere_cidr      = "0.0.0.0/0"
  db_port            = 3306
  enable_nat_gateway = true
  enable_eip         = true
  app_ingress_rules  = [
    {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}