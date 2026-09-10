provider "aws" {
  region = "us-west-2"
}

# copied from the terraform/AWS documentation
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.24.2"

  name               = "lab-cluster"
  kubernetes_version = "1.33"
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    core = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t4g.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
    node_security_group_additional_rules = {}
    enable_cluster_creator_admin_permissions = true
  }


  tags = {
    Environment = "dev"
    Terraform   = "true"
  }

  