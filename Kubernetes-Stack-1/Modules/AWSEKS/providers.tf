terraform {
  required_version = ">= 1.9.0"

  required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 6.64"
        }

      kubernetes = { 
        source = "hashicorp/kubernetes"
        version = "~> 3.2.1"
        }

      helm = {
        source  = "hashicorp/helm"
        version = "~> 3.3.0"
        }

      kubectl = {
        source = "alekc/kubectl"
        version = "3.0.0-beta3"
      }
    }
  }
