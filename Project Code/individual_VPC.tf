resource "aws_vpc" "VPC_A" {
  provider = aws.RegionA
  cidr_block = "10.0.0.0/21" 
  instance_tenancy = "default"           # Optional: Can be 'default' or 'dedicated'
  enable_dns_support      = true           # Optional: General name Enable DNS resolution () streamhub.example.com)(server can be communicated with dns name rather than ip )
  enable_dns_hostnames    = true        # Optional: Specific name  ( server1.streamhub.example.com)Enable DNS hostnames for instances
  max_az = "2"
  tags = {
    Name        = "VPC_A"        # Optional: Tag for the VPC
    Environment = "Dev"          # Optional: Example of additional tagging
    Project     = "VPC_Project" # Optional: Another tagging example
  }
 ipv6_cidr_block =  "false"
 amazon_provided_Ipv6_cidr_block= "false"
}

################################### DHCP OPTION FOR VPC  ##########################################
resource "aws_vpc_dhcp_options" "dhcp_options" {
  domain_name          = "example.com"                # Domain name for DHCP
  domain_name_servers  = ["AmazonProvidedDNS"]        # Use Amazon's DNS servers
  ntp_servers          = ["169.254.169.123"]          # Optional: NTP server for time synchronization
  netbios_name_servers = ["10.0.0.1"]                  # Optional: NetBIOS name servers
  netbios_node_type    = 8                             # Optional: NetBIOS node type

  tags = {
    Name = "My_DHCP_Options"
  }
}

# Associate DHCP Options with the VPC
resource "aws_vpc_dhcp_options_association" "assoc" {
  vpc_id          = aws_vpc.VPC.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_options.id
}

############################################################################################


resource "aws_vpc" "VPC_B" {
  provider = aws.RegionA
}

resource "aws_vpc" "VPC_C" {
  provider = aws.RegionB
}