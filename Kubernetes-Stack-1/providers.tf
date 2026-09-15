terraform {
  required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = ">= 5.95.0, < 6.0.0"
        }

      kubernetes = { 
        source = "hashicorp/kubernetes"
        version = "~> 2.38"
        }

      helm = {
        source  = "hashicorp/helm"
        version = "~> 3.2"
        }

      kubectl = {
        source = "hashicorp-oss/kubectl"
        version = "~> 0.1.13"
      }
    }
  }
