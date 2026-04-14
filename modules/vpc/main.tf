#############################################
# DATA
#############################################
data "aws_availability_zones" "available" {}

#############################################
# VPC
#############################################
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

#############################################
# INTERNET GATEWAY
#############################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

#############################################
# PUBLIC SUBNETS (MULTI-AZ)
#############################################
resource "aws_subnet" "public" {
  count = 1

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-subnet"
  }
}

#############################################
# PRIVATE SUBNETS (MULTI-AZ)
#############################################
resource "aws_subnet" "private" {
  count = 1

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.vpc_name}-private-subnet"
  }
}

#############################################
# PUBLIC ROUTE TABLE
#############################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = var.anywhere_cidr
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#############################################
# EIP (OPTIONAL)
#############################################
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway && var.enable_eip ? 1 : 0
  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}-eip"
  }
}

#############################################
# NAT GATEWAY (OPTIONAL)
#############################################
resource "aws_nat_gateway" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.vpc_name}-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

#############################################
# PRIVATE ROUTE TABLE
#############################################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

resource "aws_route" "private_nat" {
  count = var.enable_nat_gateway ? 1 : 0

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = var.anywhere_cidr
  nat_gateway_id         = aws_nat_gateway.nat[0].id
}

resource "aws_route_table_association" "private_assoc" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

#############################################
# SECURITY GROUP - APP (PUBLIC ACCESS)
#############################################
resource "aws_security_group" "app_sg" {
  name        = "${var.vpc_name}-app-sg"
  description = "App SG"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.app_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anywhere_cidr]
  }

  tags = {
    Name = "${var.vpc_name}-app-sg"
  }
}

#############################################
# SECURITY GROUP - DB (PRIVATE)
#############################################
resource "aws_security_group" "db_sg" {
  name        = "${var.vpc_name}-db-sg"
  description = "DB SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anywhere_cidr]
  }

  tags = {
    Name = "${var.vpc_name}-db-sg"
  }
}