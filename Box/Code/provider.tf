/*
required_providers:
  1-Used to specify where to get a provider (e.g., the AWS provider) 
  2- what version to use.
provider block: 
  1-Used to configure how that provider should be used in your Terraform project, 
  such as setting regions for the AWS provider or creating multiple instances of a provider with aliases.

*/


terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
  }

  backend "s3" {
    bucket = "my-terraform-bucket"
    key    = "global/terraform.tfstate"
    region = "us-west-2"
  }

  cloud {
    organization = "my-org"

    workspaces {
      name = "my-workspace"
    }
  }

  experiments = [module_variable_optional_attrs]
}


provider "local" {
  alias = "test"
}
