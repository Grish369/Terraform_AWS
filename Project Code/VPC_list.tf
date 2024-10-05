resource "aws_vpc" "main" {
  for_each = { for vpc in var.vpcs : vpc.name => vpc }
#   {
#   "VPC_A" = { name = "VPC_A", cidr_block = "10.0.0.0/21", ... }
#   "VPC_B" = { name = "VPC_B", cidr_block = "10.1.0.0/21", ... }
# }
  cidr_block           = each.value.cidr_block
  instance_tenancy    = each.value.instance_tenancy
  enable_dns_support   = each.value.enable_dns_support
  enable_dns_hostnames = each.value.enable_dns_hostnames
  tags = {
    Name        = each.value.name
    Environment = "Dev"
    Project     = "VPC_Project"
  }
}


resource "aws_vpc_dhcp_options" "dhcp_options" {
  for_each = { for vpc in var.vpcs : vpc.name => vpc }
  domain_name          = each.value.domain_name
  domain_name_servers  = ["AmazonProvidedDNS"]  # You can also customize this if needed
  ntp_servers          = each.value.ntp_servers
  netbios_name_servers = each.value.netbios_name_servers
  netbios_node_type    = each.value.netbios_node_type
  tags = {
    Name = "${each.value.name}_DHCP_Options"
  }
}

resource "aws_vpc_dhcp_options_association" "assoc" {
  for_each = aws_vpc.main
  vpc_id          = each.value.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_options[each.key].id
}