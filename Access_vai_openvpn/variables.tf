# AWS region
variable "aws_region" {
  description = "AWS region"
  type        = string
}

# VPC Variables
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "anywhere_cidr" {
  description = "CIDR for open access (0.0.0.0/0)"
  type        = string
}

variable "db_port" {
  description = "Database port for private SG"
  type        = number
}

variable "app_ingress_rules" {
  description = "Ingress rules for app security group"
  type = list(object({
    from_port       = number
    to_port       = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
}

variable "enable_eip" {
  description = "Enable EIP for NAT Gateway"
  type        = bool
}

# EC2 Variables
variable "ec2_name_prefix" {
  description = "Prefix for EC2 resources"
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ec2_ami_id" {
  description = "AMI ID for EC2 (leave empty for latest Amazon Linux 2)"
  type        = string
  default     = ""
}

variable "ec2_key_name" {
  description = "SSH key pair name for EC2"
  type        = string
}

variable "my_ip_cidr" {
  description = "Your IP CIDR for SSH access"
  type        = string
}
variable "user_data_file" {
  description = "User data file for squid proxy"
  type        = string
  default     = "./nginx_script.sh"

}
variable "create_ssm_role" {
  description = "value"
  type        = bool
  default     = false
}