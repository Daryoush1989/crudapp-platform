data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name_prefix = "${var.org_slug}-${var.project_slug}"
  azs         = slice(data.aws_availability_zones.available.names, 0, 2)

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
  app_port    = 8080
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