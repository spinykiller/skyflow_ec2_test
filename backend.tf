terraform {
  backend "s3" {
    bucket         = ""
    key            = "ec2-instances/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }

  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}