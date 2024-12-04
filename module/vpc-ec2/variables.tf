# General Configuration
variable "aws-region" {}
variable "env" {}
variable "cluster-name" {}
variable "vpc-cidr-block" {}
variable "vpc-name" {}
variable "igw-name" {}

# Subnet Configuration
variable "pub-subnet-count" {}
variable "pub-cidr-block" {
  type = list(string)
}
variable "pub-availability-zone" {
  type = list(string)
}
variable "pub-sub-name" {}
variable "pri-subnet-count" {}
variable "pri-cidr-block" {
  type = list(string)
}
variable "pri-availability-zone" {
  type = list(string)
}
variable "pri-sub-name" {}

# Route Table Configuration
variable "public-rt-name" {}
variable "private-rt-name" {}

# Elastic IP and NAT Gateway Configuration
variable "eip-names" {
  type = list(string)
}
variable "natgw-names" {
  type = list(string)
}

# Security Groups
variable "eks-sg" {}
variable "ec2-sg" {}

# IAM
variable "ec2-iam-role" {}
variable "ec2-iam-role-policy" {}
variable "ec2-iam-instance-profile" {}

# EC2
variable "ec2-name" {}
