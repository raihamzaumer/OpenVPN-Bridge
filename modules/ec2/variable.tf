variable "vpc_id" {
  description = "VPC ID where EC2 will be launched"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where EC2 will be launched"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID to use (optional, defaults to latest Amazon Linux 2)"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "my_ip_cidr" {
  description = "Your IP CIDR for SSH access"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}
variable "user_data_file" {
  description = "firle for user data"
  default = ""
  
}


variable "associate_public_ip" {
  description = "Attach public IP?"
  type        = bool
  default     = false
}

variable "create_ssm_role" {
  description = "Create SSM role for instance"
  type        = bool
  default     = false
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "List of security group IDs for EC2"
}