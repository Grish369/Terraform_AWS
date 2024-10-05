variable "region_a_vpcs" {
  description = "Details for VPCs in Region A"
  type = list(object({
    name  = string
    cidr  = string
    az    = string
  }))
  default = [
    { name = "vpc_a", cidr = "10.0.0.0/16", az = "us-east-1a" },
    { name = "vpc_b", cidr = "10.1.0.0/16", az = "us-east-1b" },
    { name = "vpc_c", cidr = "10.2.0.0/16", az = "us-east-1a" },
  ]
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnets"
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnets"
  default     = "10.0.2.0/24"
}
