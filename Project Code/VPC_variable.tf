variable "vpcs" {
  description = "List of VPC configurations"
  type = list(object({
    name                     = string
    cidr_block               = string
    enable_dns_support       = optional(bool, true)  # Default to true if not provided
    enable_dns_hostnames     = optional(bool, true)  # Default to true if not provided
    instance_tenancy         = optional(string, "default")  # Default to "default"
    max_az                   = number
    domain_name              = string
    netbios_name_servers      = list(string)
    ntp_servers              = list(string)
    netbios_node_type        = number
  }))
}
