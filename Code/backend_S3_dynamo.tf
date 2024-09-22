terraform {
  backend "s3" {
    # Required Arguments
    bucket  = "your-terraform-bucket"    # Name of the S3 bucket
    key     = "path/to/terraform.tfstate" # Path to the state file in the bucket
    region  = "us-west-1"                 # AWS region where the bucket is located

    dynamodb_table = "terraform-state-lock"   #name of table which we create in aws console for locking the state file
     # Optional for workspaces
    workspace_key_prefix = "workspaces/"  # Prefix for workspace-specific state files (Optional) # "env/" OR "dev/"


    # Optional Arguments for Authentication (can also be set via environment variables)
    access_key = "your-access-key"        # AWS access key (Optional)
    secret_key = "your-secret-key"        # AWS secret key (Optional)

    # Optional Endpoint for S3-compatible storage (use for non-AWS services)
    endpoints = {
      s3 = "https://oss.region.prod-cloud-ocb.orange-business.com"  # Custom endpoint for S3 compatible services 
                    # These services implement the same API as Amazon S3, but are provided by other cloud platforms or storage services.
    }

    # Optional flags (especially for FlexibleEngine or non-AWS services)
    skip_region_validation      = true   # Skip validation of region name (Optional)
    skip_credentials_validation = true   # Skip validation of credentials via STS API (Optional)
    skip_metadata_api_check     = true   # Skip usage of EC2 Metadata API (Optional)
    skip_requesting_account_id  = true   # Skip requesting the account ID (Optional)
    skip_s3_checksum            = true   # Skip checksum when uploading S3 objects (Optional)
  }
}



# S3 Backend:
# Purpose: Used to store Terraform state files remotely, allowing team collaboration and preventing state file conflicts.
# Storage: State files are stored in an S3 bucket, providing durability and availability.
# DynamoDB for State Locking:

# Lock Mechanism: DynamoDB is used to manage state locking, ensuring that only one user can modify the state file at a time.
# Performance: DynamoDB provides low-latency operations, making it ideal for quick lock and unlock operations.
# Cost: It operates on a pay-per-request model, which can be cost-effective for state locking.
# Why Not Use DynamoDB for State Storage:

# State Management: S3 is designed for object storage, which makes it more suitable for storing large state files efficiently.
# Versioning: S3 supports versioning, allowing for easy rollbacks if needed, which is not inherently supported in DynamoDB.
# Simplicity: Using S3 for state files and DynamoDB for locking separates concerns, simplifying management and reducing complexity.
