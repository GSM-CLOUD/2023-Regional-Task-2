provider "aws" {
  region = var.region
  profile = var.awscli_profile
}

terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = ">= 4.0"
      }
      time = {
        source = "hashicorp/time"
        version = "~> 0.9"
      }
    }
}