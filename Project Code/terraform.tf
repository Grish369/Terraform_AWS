terraform {
   required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
   }  
}

provider "aws" {
    alias = "RegionA"
    region = "us-west-1"
}

provider "aws" {
    alias = "RegionB"
    region = "us-west-2"
}