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
  type        = list(string)
  description = "List of Elastic IP names for NAT Gateways"
}
variable "natgw-names" {
  type        = list(string)
  description = "List of NAT Gateway names per availability zone"
}

# Security Groups
variable "eks-sg" {}

# EKS Configuration
variable "is-eks-cluster-enabled" {}
variable "cluster-version" {}
variable "endpoint-private-access" {}
variable "endpoint-public-access" {}
variable "ondemand_instance_types" {
  default = ["t3.small"]
}
variable "spot_instance_types" {}
variable "desired_capacity_on_demand" {}
variable "min_capacity_on_demand" {}
variable "max_capacity_on_demand" {}
variable "desired_capacity_spot" {}
variable "min_capacity_spot" {}
variable "max_capacity_spot" {}
variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
}
