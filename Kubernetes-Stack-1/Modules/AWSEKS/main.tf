terraform {
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = "3.0.0-beta3"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}
      
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

provider "helm" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
        api_version = "client.authentication.k8s.io/v1beta1"
        command     = "aws"
        args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      }
}

provider "kubectl" {
  apply_retry_count      = 5
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      }
    }

# copied from the terraform/AWS documentation
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.25.0"

  name               = "lab-cluster"
  kubernetes_version = "1.33"
  
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
}
