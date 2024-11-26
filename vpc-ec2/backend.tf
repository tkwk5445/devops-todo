terraform {
  required_version = "~> 1.9.5"
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
    bucket         = "todo-bucket"
    region         = "us-east-1"
    key            = "vpc/terraform.tfstate"
    dynamodb_table = "todo-tf-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws-region
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "todo-tf-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}