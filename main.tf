locals {
  region = "us-east-1"
  app_name = "dh-test"
  vpc_id = "vpc-0de75e5dbd2ec5db6"
  subnet_a_id = "subnet-02575277ab34df3c5"
  subnet_b_id = "subnet-05f7a5679527efab5"

  tags = {
    Environment = "dev"
    Application = "vprofile"
  }
}




module "ecs_sg" {
  source = "./modules/sg"
  vpc_id = local.vpc_id
  app_name = local.app_name
  tags = local.tags
}

module "roles" {
  source = "./modules/roles"
  app_name = local.app_name
  tags = local.tags
  
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  app_name = local.app_name
  tags = local.tags
  
}

module "eks" {
  source = "./modules/eks"
  app_name = local.app_name
  tags = local.tags
}

module "alb" {
  source = "./modules/alb"
  app_name = local.app_name
  tags = local.tags
  vpc_id = local.vpc_id
  subnets = [ local.subnet_a_id, local.subnet_b_id ]
  ecs_alb_sg = module.ecs_sg.ecs_alb_sg
  
}

module "task_definition" {
  source = "./modules/ecs-task"
  app_name = local.app_name
  tags = local.tags
  execution_role_arn = module.roles.ecs_role.arn
  cloudwatch = module.cloudwatch.cloudwatch_log_group
  repository_url = module.eks.eks_repository.repository_url
}


module "ecs_cluster" {
  source = "./modules/ecs_cluster"
  app_name = local.app_name
  tags = local.tags
}


module "ecs_service" {
  source = "./modules/ecs_service"
  app_name = local.app_name
  tags = local.tags
  subnets = [local.subnet_a_id, local.subnet_b_id]
  security_groups = module.ecs_sg.ecs_sg.id
  ecs_task_definition_arn = module.task_definition.task_definition.arn
  ecs_cluster = module.ecs_cluster.ecs_cluster
  alb_target_group = module.alb.alb_target_group
  
}

