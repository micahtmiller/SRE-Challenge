provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}

locals {
  k8s_version             = "1.18"
  vpc_id                  = "vpc-01b7316a"
  subnet_id_a             = "subnet-2e367962"
  subnet_id_b             = "subnet-1f6d8962"
  subnet_id_c             = "subnet-c571dfae"
}

module "dynamic-enablement-cluster" {
  providers = {
    aws = aws.us-east-2
  }
  source = "../../../modules/eks-cluster"

  eks_name = "dynamic-enablement"
  subnet_ids = [
    local.subnet_id_a,
    local.subnet_id_b,
    local.subnet_id_c,
  ]
}