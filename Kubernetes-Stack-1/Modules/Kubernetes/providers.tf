terraform{
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.38"
    }
    
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"

        exec = {
          api_version = "client.authentication.k8s.io/v1beta1"
          command     = "aws"
          args        = ["eks", "get-token", "--cluster-name", module.eks.lab-cluster]
        }
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.2"

        exec = {
          api_version = "client.authentication.k8s.io/v1beta1"
          command     = "aws"
          args        = ["eks", "get-token", "--cluster-name", module.eks.lab-cluster]
        }
    }

    kubectl = {
      source = "hashicorp-oss/kubectl"
      version = "~> 0.1.13"

        exec = {
          api_version = "client.authentication.k8s.io/v1beta1"
          command     = "aws"
          args        = ["eks", "get-token", "--cluster-name", module.eks.lab-cluster]
        }
    }
  }
}