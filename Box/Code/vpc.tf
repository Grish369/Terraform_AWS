provider "aws" {
  region = "us-east-1" # Change to your desired region
}

# VPC A
resource "aws_vpc" "vpc_a" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# VPC B
resource "aws_vpc" "vpc_b" {
  cidr_block = "10.1.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# VPC C
resource "aws_vpc" "vpc_c" {
  cidr_block = "10.2.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Subnets for VPC A
resource "aws_subnet" "subnet_a_pub" {
  vpc_id     = aws_vpc.vpc_a.id
  cidr_block = "10.0.1.0/24" # Public Subnet
  availability_zone = "us-east-1a" # Change as needed
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_a_priv" {
  vpc_id     = aws_vpc.vpc_a.id
  cidr_block = "10.0.2.0/24" # Private Subnet
  availability_zone = "us-east-1a" # Change as needed
}

# Subnets for VPC B
resource "aws_subnet" "subnet_b_pub" {
  vpc_id     = aws_vpc.vpc_b.id
  cidr_block = "10.1.1.0/24" # Public Subnet
  availability_zone = "us-east-1b" # Change as needed
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_b_priv" {
  vpc_id     = aws_vpc.vpc_b.id
  cidr_block = "10.1.2.0/24" # Private Subnet
  availability_zone = "us-east-1b" # Change as needed
}

# Subnets for VPC C
resource "aws_subnet" "subnet_c_pub" {
  vpc_id     = aws_vpc.vpc_c.id
  cidr_block = "10.2.1.0/24" # Public Subnet
  availability_zone = "us-east-1a" # Change as needed
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_c_priv" {
  vpc_id     = aws_vpc.vpc_c.id
  cidr_block = "10.2.2.0/24" # Private Subnet
  availability_zone = "us-east-1a" # Change as needed
}

# Internet Gateway for VPC A
resource "aws_internet_gateway" "igw_a" {
  vpc_id = aws_vpc.vpc_a.id
}

# NAT Gateway for VPC C
resource "aws_eip" "nat_eip" {}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id    = aws_subnet.subnet_c_pub.id
}

# Route Table for VPC A
resource "aws_route_table" "route_table_a" {
  vpc_id = aws_vpc.vpc_a.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_a.id
  }
}

resource "aws_route_table_association" "rta_pub_a" {
  subnet_id      = aws_subnet.subnet_a_pub.id
  route_table_id = aws_route_table.route_table_a.id
}

resource "aws_route_table_association" "rta_priv_a" {
  subnet_id      = aws_subnet.subnet_a_priv.id
  route_table_id = aws_route_table.route_table_a.id
}

# Route Table for VPC C
resource "aws_route_table" "route_table_c" {
  vpc_id = aws_vpc.vpc_c.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "rta_pub_c" {
  subnet_id      = aws_subnet.subnet_c_pub.id
  route_table_id = aws_route_table.route_table_c.id
}

resource "aws_route_table_association" "rta_priv_c" {
  subnet_id      = aws_subnet.subnet_c_priv.id
  route_table_id = aws_route_table.route_table_c.id
}

# VPC Peering between VPC A and VPC B
resource "aws_vpc_peering_connection" "peer_ab" {
  vpc_id        = aws_vpc.vpc_a.id
  peer_vpc_id   = aws_vpc.vpc_b.id
}

# VPC Peering between VPC A and VPC C
resource "aws_vpc_peering_connection" "peer_ac" {
  vpc_id        = aws_vpc.vpc_a.id
  peer_vpc_id   = aws_vpc.vpc_c.id
}

# Route Tables for Peering Connections
resource "aws_route" "route_to_b" {
  route_table_id            = aws_route_table.route_table_a.id
  destination_cidr_block    = aws_vpc.vpc_b.cidr_block
  vpc_peering_connection_id  = aws_vpc_peering_connection.peer_ab.id
}

resource "aws_route" "route_to_c" {
  route_table_id            = aws_route_table.route_table_a.id
  destination_cidr_block    = aws_vpc.vpc_c.cidr_block
  vpc_peering_connection_id  = aws_vpc_peering_connection.peer_ac.id
}

resource "aws_route" "route_from_b" {
  route_table_id            = aws_route_table.route_table_b.id
  destination_cidr_block    = aws_vpc.vpc_a.cidr_block
  vpc_peering_connection_id  = aws_vpc_peering_connection.peer_ab.id
}

resource "aws_route" "route_from_c" {
  route_table_id            = aws_route_table.route_table_c.id
  destination_cidr_block    = aws_vpc.vpc_a.cidr_block
  vpc_peering_connection_id  = aws_vpc_peering_connection.peer_ac.id
}
