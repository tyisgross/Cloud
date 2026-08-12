provider "aws" {
  region = "us-west-2"
}

module "infrastructure" {
  source = "./modules/infrastructure"
}

module "eks" {
  source = "./modules/eks"

  vpc_id     = module.infrastructure.vpc_id
  subnet_ids = module.infrastructure.private_subnets
}