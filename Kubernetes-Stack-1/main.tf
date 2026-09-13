provider "aws" {
  region = "us-west-2"
}

module "infrastructure" {
  source = "./Modules/Infrastructure"
}

module "eks" {
  source = "./Modules/AWSEKS"

  vpc_id     = module.infrastructure.vpc_id
  subnet_ids = module.infrastructure.private_subnets
}

module "kubernetes" {
  source = "./Modules/Kubernetes"


}