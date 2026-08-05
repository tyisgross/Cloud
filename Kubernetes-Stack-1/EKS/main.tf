provider "aws" {
  region = "us-west-2"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "eks_lab"
  kubernetes_version = "1.33"

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  compute_config = {
    enabled    = false
    node_pools = ["general-purpose"]
  }

  vpc_id     = "aws_vpc.network.id"
  subnet_ids = ["aws_subnet.private_a.id", "aws_subnet.private_b.id"]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}


data "terraform_remote_state" "network" {

}

data "terraform_remote_state" "shared"

data "terraform_remote_state" "security"

module "eks"

cluster_name = "lab-eks"

