provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = var.project
      Environment = var.environment
      Owner       = var.owner
    }
  }
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

module "ecs" {
  source = "./modules/ecs"

  cluster_name          = var.cluster_name
  app_name              = var.app_name
  vpc_id                = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnets
  public_subnets        = module.vpc.public_subnets
  alb_security_group_id = module.ecs.alb_sg_id
  app_security_group_id = module.ecs.app_sg_id
  container_image       = "${module.ecs.repository_url}:latest"
  container_port        = var.container_port
  aws_region            = var.region
}

