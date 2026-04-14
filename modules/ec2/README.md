# EC2 Module

This Terraform module creates an EC2 instance in a public subnet with the following features:

- Amazon Linux 2 AMI by default (or custom AMI)
- Nginx installed and started via inline user data
- IAM Role with SSM Managed Instance Core for remote management
- Security group allowing:
  - SSH only from your IP
  - HTTP from anywhere
- Fully tagged and industry-standard

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| vpc_id | VPC ID to launch EC2 in | string | - |
| public_subnet_ids | List of public subnet IDs | list(string) | - |
| instance_type | EC2 instance type | string | t3.micro |
| ami_id | Optional AMI ID | string | latest Amazon Linux 2 |
| key_name | SSH key pair name | string | - |
| my_ip_cidr | Your IP for SSH access | string | - |
| name_prefix | Prefix for naming resources | string | - |

## Outputs

- `ec2_id` – The ID of the EC2 instance  
- `ec2_public_ip` – Public IP of the EC2 instance  
- `ec2_sg_id` – Security Group ID attached to EC2