#!/bin/bash

# Terraform, AWS CLI, Kubectl 버전 확인
echo "Checking versions..."
echo "Terraform version:"
terraform version

echo "AWS CLI version:"
aws --version

echo "Kubectl version:"
kubectl version --client --short

# AWS CLI 구성
echo "Configuring AWS CLI..."
aws configure

# Terraform 초기화 및 검증
echo "Initializing Terraform..."
terraform init

echo "Validating Terraform configuration..."
terraform validate

# Terraform 계획
echo "Planning Terraform..."
terraform plan -var-file=../variables.tfvars

# Terraform 적용 여부 확인
echo "Apply Terraform..."
terraform apply -var-file=../variables.tfvars 