required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.38"
    }
    
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.2"
    }
  }