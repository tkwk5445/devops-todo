terraform {
  required_version = "~> 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.31.0"
    }
  }
  backend "s3" {
    bucket         = "wj-todo-s3"
    region         = "us-east-2"
    key            = "vpc/terraform.tfstate"
    dynamodb_table = "wj-todo-tf-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws-region
}

