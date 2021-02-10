provider "aws" {
  alias = "us-east-2"
  region = "us-east-2"
}

locals {
  vpc_id = "vpc-01b7316a"
  subnet_id_a = "subnet-2e367962"
  subnet_id_b = "subnet-1f6d8962"
  subnet_id_c = "subnet-c571dfae"
}

module "dynamic-enablement-node-group" {
  source = "../../../modules/eks-node-group"

  cluster_name = "dynamic-enablement"
  node_group_name = "dynamic-enablement-node-group"

  subnet_ids = [
    local.subnet_id_a,
    local.subnet_id_b,
    local.subnet_id_c,
  ]

}