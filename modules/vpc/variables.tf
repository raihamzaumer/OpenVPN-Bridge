variable "vpc_name" {}
variable "vpc_cidr" {}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "enable_nat_gateway" {
  type = bool
}

variable "enable_eip" {
  type = bool
}

variable "anywhere_cidr" {
  default = "0.0.0.0/0"
}

variable "app_ingress_rules" {
  type = list(object({
    from_port        = number
    to_port         = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "db_port" {
  type = number
}