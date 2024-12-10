env                   = "prod"
aws-region            = "ap-northeast-2"
vpc-cidr-block        = "10.16.0.0/16"
vpc-name              = "vpc"
igw-name              = "igw"
pub-subnet-count      = 2
pub-cidr-block        = ["10.16.0.0/20", "10.16.16.0/20"]
pub-availability-zone = ["ap-northeast-2a", "ap-northeast-2c"]
pub-sub-name          = "public-subnet"
pri-subnet-count      = 2
pri-cidr-block        = ["10.16.128.0/20", "10.16.144.0/20"]
pri-availability-zone = ["ap-northeast-2a", "ap-northeast-2c"]
pri-sub-name          = "private-subnet"
public-rt-name        = "public-route-table"
private-rt-name       = "private-route-table"
eip-names             = ["elasticip-natgw-2a", "elasticip-natgw-2c"] # Elastic IP 이름
natgw-names           = ["natgw-2a", "natgw-2c"]                     # NAT Gateway 이름
eks-sg                = "eks-sg"
ec2-sg                = "ec2-sg"

# EKS
is-eks-cluster-enabled     = true
cluster-version            = "1.31"
cluster-name               = "eks-cluster"
endpoint-private-access    = true
endpoint-public-access     = false
ondemand_instance_types    = ["t3.medium"]
spot_instance_types        = ["c5a.large", "c5a.xlarge", "m5a.large", "m5a.xlarge", "c5.large", "m5.large", "t3a.large", "t3a.xlarge", "t3.medium"]
desired_capacity_on_demand = "1"
min_capacity_on_demand     = "1"
max_capacity_on_demand     = "5"
desired_capacity_spot      = "1"
min_capacity_spot          = "1"
max_capacity_spot          = "10"
addons = [
  {
    name    = "vpc-cni",
    version = "v1.18.1-eksbuild.1"
  },
  {
    name    = "coredns"
    version = "v1.11.1-eksbuild.9"
  },
  {
    name    = "kube-proxy"
    version = "v1.29.3-eksbuild.2"
  },
  {
    name    = "aws-ebs-csi-driver"
    version = "v1.30.0-eksbuild.1"
  }
  # Add more addons as needed
]

# IAM 
ec2-iam-role             = "ec2-ssm-role"
ec2-iam-role-policy      = "ec2-ssm-role-policy"
ec2-iam-instance-profile = "ec2-ssm-instance-profile"

# EC2
ec2-name = "[EKS] Bastion-Jenkins"
