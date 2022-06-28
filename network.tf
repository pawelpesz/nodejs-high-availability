resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az_number = length(data.aws_availability_zones.available.names)
}

resource "aws_subnet" "subnet" {
  count                   = local.az_number
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

resource "aws_route_table_association" "subnet" {
  count          = local.az_number
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_vpc.vpc.default_route_table_id
}

resource "aws_security_group" "app" {
  name        = "app"
  description = "Allow HTTP@${var.app_port} to instances"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "HTTP@${var.app_port} access"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.http.name]
  }

  egress {
    description = "To Internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
