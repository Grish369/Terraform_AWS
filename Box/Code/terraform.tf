terraform {
  required_version = ">= 1.0.0"
  required_providers = {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "path/to/my/key"
    region = "us-west-2"
  }
  cloud {
    organization = "my-org"
    workspaces = {
      name = "production"
    }
    token = "my-secret-token"
  }

  experiments = ["feature-flag"]
}
