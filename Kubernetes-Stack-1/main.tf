provider "aws" {
  region = "us-west-2"
}

module "infrastructure" {
  source = "./Modules/Infrastructure"
}

module "eks" {
  source = "./Modules/AWSEKS"
  control_plane_subnet_ids = module.infrastructure.private_subnets
  vpc_id     = module.infrastructure.vpc_id
  private_subnets = module.infrastructure.private_subnets
}

module "kubernetes" {
  source = "./Modules/Kubernetes"


}