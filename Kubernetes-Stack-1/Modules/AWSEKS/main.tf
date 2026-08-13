provider "aws" {
  region = "us-west-2"
}

# copied from the terraform/AWS documentation
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.24.2"

  name               = "lab-cluster"
  kubernetes_version = "1.33"

  addons = {
  coredns                = {}
  eks-pod-identity-agent = {
    before_compute = true
    }
  kube-proxy             = {}
  vpc-cni                = {
    before_compute = true
    }
  }

  # Optional
  endpoint_public_access = true

    # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    example = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m5.xlarge"]

      min_size     = 2
      max_size     = 10
      desired_size = 2
    }
  }


  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}