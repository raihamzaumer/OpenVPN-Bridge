aws_region = "eu-north-1"
#vpc

vpc_cidr        = "10.0.0.0/16"
vpc_name        = "prod-vpc"
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
anywhere_cidr   = "0.0.0.0/0"
db_port         = 80
app_ingress_rules = [ 
{ from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["182.189.9.19/32"] },
{ from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
{ from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
{ from_port = 943, to_port = 943, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
{ from_port = 1194, to_port = 1194, protocol = "udp", cidr_blocks = ["0.0.0.0/0"] }
 ]

# Ec2
enable_nat_gateway = true
enable_eip         = true
ec2_name_prefix    = "prod-app"
ec2_instance_type  = "t3.micro"
ec2_ami_id         = "ami-080254318c2d8932f" # leave empty to use latest Amazon Linux 2
ec2_key_name       = "My-key-Pair"
my_ip_cidr         = "182.189.9.19/32"
user_data_file     = "./openVpn.sh"