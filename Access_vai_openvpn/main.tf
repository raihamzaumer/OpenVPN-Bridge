provider "aws" {
  region = var.aws_region
}
module "vpc" {
  source   = "../modules/vpc"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = var.enable_nat_gateway
  enable_eip         = var.enable_eip

  anywhere_cidr     = var.anywhere_cidr
  app_ingress_rules = var.app_ingress_rules 
  db_port           = var.db_port


}
module "proxy_ec2" {
  source = "../modules/ec2"

  name_prefix    = "OpenVpn"
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids = [module.vpc.app_sg.id]
  instance_type  = "t3.micro"
  ami_id         = var.ec2_ami_id
  key_name       = var.ec2_key_name
  my_ip_cidr     = var.my_ip_cidr
  user_data_file = "./openVpn.sh"
  associate_public_ip = true
  create_ssm_role     = true
  
}

module "private_app_ec2" {
  source = "../modules/ec2"

  name_prefix    = "private-nginx"
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.vpc.private_subnet_ids[0]
  instance_type  = "t3.micro"
  vpc_security_group_ids = [module.vpc.db_sg.id]
  ami_id         = var.ec2_ami_id
  key_name       = var.ec2_key_name
  my_ip_cidr     = var.my_ip_cidr
  depends_on = [ module.proxy_ec2 ]
  user_data_file = "./nginx_script.sh"
  associate_public_ip = false
  create_ssm_role     = true
}


resource "aws_security_group_rule" "vpn_access" {
type = "ingress"
from_port= 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["172.27.232.0/22"] # Default/Dynamic VPN subnet
security_group_id = module.vpc.db_sg.id
}
