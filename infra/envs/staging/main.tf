data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

locals {
  name_prefix        = "${var.org_slug}-${var.project_slug}"
  azs                = slice(data.aws_availability_zones.available.names, 0, 2)
  ecr_repository_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.org_slug}/${var.project_slug}/api"

  common_tags = {
    Project     = var.project_slug
    ManagedBy   = "Terraform"
    Owner       = var.owner
    Repository  = "crudapp-platform"
    Environment = var.environment
    Application = "crudapp-platform"
  }
}

module "network" {
  source = "../../modules/network"

  name_prefix               = local.name_prefix
  aws_region                = var.aws_region
  vpc_cidr                  = var.vpc_cidr
  azs                       = local.azs
  public_subnet_cidrs       = var.public_subnet_cidrs
  private_app_subnet_cidrs  = var.private_app_subnet_cidrs
  private_data_subnet_cidrs = var.private_data_subnet_cidrs
  tags                      = local.common_tags
}

module "security" {
  source = "../../modules/security"

  name_prefix = local.name_prefix
  environment = var.environment
  vpc_id      = module.network.vpc_id
  app_port    = var.api_container_port
  db_port     = 5432
  tags        = local.common_tags
}

module "database" {
  source = "../../modules/database"

  name_prefix             = local.name_prefix
  environment             = var.environment
  private_data_subnet_ids = module.network.private_data_subnet_ids
  db_security_group_id    = module.security.db_security_group_id

  db_name                = var.db_name
  master_username        = var.db_master_username
  engine_version         = var.db_engine_version
  parameter_group_family = var.db_parameter_group_family
  instance_class         = var.db_instance_class

  allocated_storage             = 20
  max_allocated_storage         = 100
  backup_retention_period       = 7
  cloudwatch_log_retention_days = 7
  multi_az                      = false
  deletion_protection           = false
  skip_final_snapshot           = true
  apply_immediately             = true

  tags = local.common_tags
}

module "vpc_endpoints" {
  source = "../../modules/vpc_endpoints"

  name_prefix            = local.name_prefix
  environment            = var.environment
  aws_region             = var.aws_region
  vpc_id                 = module.network.vpc_id
  private_app_subnet_ids = module.network.private_app_subnet_ids
  app_security_group_id  = module.security.app_security_group_id
  tags                   = local.common_tags
}

module "ecs_api" {
  source = "../../modules/ecs"

  name_prefix               = local.name_prefix
  environment               = var.environment
  aws_region                = var.aws_region
  ecr_repository_url        = local.ecr_repository_url
  api_image_tag             = var.api_image_tag
  private_app_subnet_ids    = module.network.private_app_subnet_ids
  app_security_group_id     = module.security.app_security_group_id
  api_container_port        = var.api_container_port
  api_cpu                   = var.api_cpu
  api_memory                = var.api_memory
  api_desired_count         = var.api_desired_count
  api_log_retention_days    = var.api_log_retention_days
  fargate_platform_version  = var.fargate_platform_version
  db_host                   = module.database.db_address
  db_port                   = module.database.db_port
  db_name                   = module.database.db_name
  db_master_user_secret_arn = module.database.db_master_user_secret_arn
  enable_container_insights = false
  tags                      = local.common_tags

  depends_on = [
    module.vpc_endpoints
  ]
}