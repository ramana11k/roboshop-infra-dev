terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.33.0"
    }
  }
  
  backend "s3" {
    bucket = "nikhils3-state-dev"
    key    = "web-alb"
    region = "us-east-1"
    dynamodb_table = "nikhils3-locking-dev"

  }
}


provider "aws" {
    region="us-east-1"
  # Configuration options
}