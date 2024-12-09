terraform {
  required_version = "~> 1.6.6"
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
    bucket         = "wookja-todo-s3"
    region         = "ap-northeast-2"
    key            = "eks/terraform.tfstate"
    dynamodb_table = "wookja-todo-tf-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws-region
}

