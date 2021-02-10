locals{

}

resource "aws_iam_role" "dyn_enablement_eks_cluster" {
  name = "dyn-enablement-eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.dyn_enablement_eks_cluster.name
}


resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.dyn_enablement_eks_cluster.name
}

resource "aws_eks_cluster" "aws_eks" {
  name      = var.eks_name
  role_arn = aws_iam_role.dyn_enablement_eks_cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  tags = {
    ManagedBy = "Terraform"
  }
}

