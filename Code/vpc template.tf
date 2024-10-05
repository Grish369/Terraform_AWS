provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc" {
  for_each = { for vpc in var.region_a_vpcs : vpc.name => vpc }
  cidr_block = each.value.cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = each.value.name
  }
}

resource "aws_subnet" "private_subnet" {
  for_each = { for vpc in var.region_a_vpcs : vpc.name => vpc }

  vpc_id            = aws_vpc.vpc[each.key].id
  cidr_block        = var.private_subnet_cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = false

  tags = {
    Name = "${each.value.name}-private"
  }
}

resource "aws_subnet" "public_subnet" {
  for_each = { for vpc in var.region_a_vpcs : vpc.name => vpc }

  vpc_id            = aws_vpc.vpc[each.key].id
  cidr_block        = var.public_subnet_cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = "${each.value.name}-public"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id    = aws_subnet.public_subnet[vpc_c].id

  depends_on = [aws_subnet.public_subnet]
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_route_table" "private_route_table" {
  for_each = { for vpc in var.region_a_vpcs : vpc.name => vpc }

  vpc_id = aws_vpc.vpc[each.key].id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${each.value.name}-private-rt"
  }
}

resource "aws_route_table_association" "private_association" {
  for_each = { for vpc in var.region_a_vpcs : vpc.name => vpc }

  subnet_id      = aws_subnet.private_subnet[each.key].id
  route_table_id = aws_route_table.private_route_table[each.key].id
}

resource "aws_vpc_peering_connection" "peer_a_b" {
  vpc_id        = aws_vpc.vpc["vpc_a"].id
  peer_vpc_id   = aws_vpc.vpc["vpc_b"].id
  auto_accept    = false
}

resource "aws_vpc_peering_connection" "peer_a_c" {
  vpc_id        = aws_vpc.vpc["vpc_a"].id
  peer_vpc_id   = aws_vpc.vpc["vpc_c"].id
  auto_accept    = false
}
