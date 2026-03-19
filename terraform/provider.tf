terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

provider "aws" {
  profile = "frandi"
  region  = "ap-southeast-1"
}

locals {
  common_tags = {
    Project     = "demo-todo-app"
    Environment = "UAT"
    Managedby   = "Terraform"
    Owner       = "DevOps Team"
  }
}