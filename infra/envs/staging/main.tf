data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ecr_repository" "api" {
  name = "${var.org_slug}/${var.project_slug}/api"
}

data "aws_caller_identity" "current" {}

locals {
  name_prefix = "${var.org_slug}-${var.project_slug}"
  azs         = slice(data.aws_availability_zones.available.names, 0, 2)

  app_fqdn            = "${var.app_subdomain}.${var.domain_name}"
  alb_name            = "cd-crudapp-stg-alb"
  api_tg_name         = "cd-crudapp-stg-api-tg"
  alb_logs_bucket     = "cd-crudapp-stg-alb-logs-${data.aws_caller_identity.current.account_id}-${var.aws_region}"
  api_container_image = "${data.aws_ecr_repository.api.repository_url}:${var.api_image_tag}"

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
module "alb_logs" {
  source = "../../modules/alb_logs"

  bucket_name        = local.alb_logs_bucket
  aws_region         = var.aws_region
  log_prefix         = "alb"
  log_retention_days = var.alb_access_log_retention_days
  force_destroy      = var.allow_force_destroy_alb_logs

  tags = local.common_tags
}

module "acm" {
  source = "../../modules/acm"

  domain_name             = var.domain_name
  certificate_domain_name = local.app_fqdn

  tags = local.common_tags
}

module "alb" {
  source = "../../modules/alb"

  load_balancer_name      = local.alb_name
  target_group_name       = local.api_tg_name
  vpc_id                  = module.network.vpc_id
  public_subnet_ids       = module.network.public_subnet_ids
  alb_security_group_id   = module.security.alb_security_group_id
  container_port          = var.api_container_port
  health_check_path       = "/health/ready"
  certificate_arn         = module.acm.certificate_arn
  access_logs_bucket_name = module.alb_logs.bucket_name
  access_logs_prefix      = module.alb_logs.log_prefix

  tags = local.common_tags

  depends_on = [
    module.alb_logs
  ]
}

module "ecs_api" {
  source = "../../modules/ecs"

  name_prefix            = local.name_prefix
  environment            = var.environment
  aws_region             = var.aws_region
  container_image        = local.api_container_image
  private_app_subnet_ids = module.network.private_app_subnet_ids
  app_security_group_id  = module.security.app_security_group_id

  db_host       = module.database.db_address
  db_port       = module.database.db_port
  db_name       = module.database.db_name
  db_secret_arn = module.database.db_master_user_secret_arn

  container_port                    = var.api_container_port
  task_cpu                          = var.api_cpu
  task_memory                       = var.api_memory
  desired_count                     = var.api_desired_count
  log_retention_days                = var.api_log_retention_days
  fargate_platform_version          = var.fargate_platform_version
  target_group_arn                  = module.alb.api_target_group_arn
  health_check_grace_period_seconds = 120

  tags = local.common_tags

  depends_on = [
    module.vpc_endpoints,
    module.alb
  ]
}

module "dns" {
  source = "../../modules/dns"

  domain_name            = var.domain_name
  record_name            = var.app_subdomain
  alb_dns_name           = module.alb.alb_dns_name
  alb_zone_id            = module.alb.alb_zone_id
  evaluate_target_health = true
}
module "observability" {
  source = "../../modules/observability"

  name_prefix                         = local.name_prefix
  environment                         = var.environment
  aws_region                          = var.aws_region
  public_app_url                      = "https://${var.app_subdomain}.${var.domain_name}"
  alb_arn_suffix                      = module.alb.alb_arn_suffix
  target_group_arn_suffix             = module.alb.api_target_group_arn_suffix
  ecs_cluster_name                    = module.ecs_api.ecs_cluster_name
  ecs_service_name                    = module.ecs_api.api_service_name
  api_log_group_name                  = module.ecs_api.api_log_group_name
  db_instance_identifier              = module.database.db_instance_identifier
  alert_email                         = var.alert_email
  alb_5xx_threshold                   = var.alb_5xx_threshold
  alb_response_time_threshold_seconds = var.alb_response_time_threshold_seconds
  ecs_cpu_threshold                   = var.ecs_cpu_threshold
  ecs_memory_threshold                = var.ecs_memory_threshold
  rds_cpu_threshold                   = var.rds_cpu_threshold
  rds_free_storage_threshold_bytes    = var.rds_free_storage_threshold_bytes

  tags = local.common_tags
}


module "waf" {
  source = "../../modules/waf"

  name_prefix = local.name_prefix
  environment = var.environment
  alb_arn     = module.alb.alb_arn
  rate_limit  = var.waf_rate_limit

  tags = local.common_tags
}

module "ecs_autoscaling" {
  source = "../../modules/ecs_autoscaling"

  name_prefix      = local.name_prefix
  environment      = var.environment
  ecs_cluster_name = module.ecs_api.ecs_cluster_name
  ecs_service_name = module.ecs_api.api_service_name

  min_capacity        = var.ecs_autoscaling_min_capacity
  max_capacity        = var.ecs_autoscaling_max_capacity
  cpu_target_value    = var.ecs_autoscaling_cpu_target
  memory_target_value = var.ecs_autoscaling_memory_target

  tags = local.common_tags
}

module "backup" {
  source = "../../modules/backup"

  name_prefix          = local.name_prefix
  environment          = var.environment
  backup_resource_arns = [module.database.db_instance_arn]
  backup_schedule      = var.backup_schedule
  delete_after_days    = var.backup_delete_after_days

  tags = local.common_tags
}

