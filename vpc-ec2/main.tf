locals {
  org = "todo"
  env = var.env
}

module "vpc-ec2" {
  source = "../module/vpc-ec2"

  env                   = var.env
  aws-region            = var.aws-region # aws-region 추가
  cluster-name          = "${local.env}-${local.org}-${var.cluster-name}"
  vpc-cidr-block        = var.vpc-cidr-block # 올바른 변수명 사용
  vpc-name              = "${local.env}-${local.org}-${var.vpc-name}"
  igw-name              = "${local.env}-${local.org}-${var.igw-name}"
  pub-subnet-count      = var.pub-subnet-count
  pub-cidr-block        = var.pub-cidr-block
  pub-availability-zone = var.pub-availability-zone
  pub-sub-name          = "${local.env}-${local.org}-${var.pub-sub-name}"
  pri-subnet-count      = var.pri-subnet-count
  pri-cidr-block        = var.pri-cidr-block
  pri-availability-zone = var.pri-availability-zone
  pri-sub-name          = "${local.env}-${local.org}-${var.pri-sub-name}"
  public-rt-name        = "${local.env}-${local.org}-${var.public-rt-name}"
  private-rt-name       = "${local.env}-${local.org}-${var.private-rt-name}"
  eip-names             = [for index, name in var.eip-names : "${local.env}-${local.org}-${name}"]
  natgw-names           = [for index, name in var.natgw-names : "${local.env}-${local.org}-${name}"]
  eks-sg                = var.eks-sg
  ec2-sg                = var.ec2-sg

  ec2-iam-role             = var.ec2-iam-role
  ec2-iam-role-policy      = var.ec2-iam-role-policy
  ec2-iam-instance-profile = var.ec2-iam-instance-profile

  ec2-name = var.ec2-name
}
