output "availability_zones" {
  description = "Availability Zones used by staging."
  value       = local.azs
}

output "vpc_id" {
  description = "Staging VPC ID."
  value       = module.network.vpc_id
}

output "vpc_cidr_block" {
  description = "Staging VPC CIDR block."
  value       = module.network.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs for future ALB."
  value       = module.network.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private app subnet IDs for ECS tasks."
  value       = module.network.private_app_subnet_ids
}

output "private_data_subnet_ids" {
  description = "Private data subnet IDs for RDS."
  value       = module.network.private_data_subnet_ids
}

output "public_route_table_id" {
  description = "Public route table ID."
  value       = module.network.public_route_table_id
}

output "s3_gateway_endpoint_id" {
  description = "S3 Gateway endpoint ID."
  value       = module.network.s3_gateway_endpoint_id
}

output "alb_security_group_id" {
  description = "Future ALB security group ID."
  value       = module.security.alb_security_group_id
}

output "app_security_group_id" {
  description = "ECS app security group ID."
  value       = module.security.app_security_group_id
}

output "db_security_group_id" {
  description = "RDS DB security group ID."
  value       = module.security.db_security_group_id
}

output "endpoint_security_group_id" {
  description = "Interface endpoint security group ID."
  value       = module.vpc_endpoints.endpoint_security_group_id
}

output "interface_endpoint_ids" {
  description = "Interface VPC endpoint IDs."
  value       = module.vpc_endpoints.interface_endpoint_ids
}

output "db_instance_identifier" {
  description = "RDS DB instance identifier."
  value       = module.database.db_instance_identifier
}

output "db_address" {
  description = "RDS DB address."
  value       = module.database.db_address
}

output "db_endpoint" {
  description = "RDS DB endpoint."
  value       = module.database.db_endpoint
}

output "db_port" {
  description = "RDS DB port."
  value       = module.database.db_port
}

output "db_name" {
  description = "Database name."
  value       = module.database.db_name
}

output "db_master_user_secret_arn" {
  description = "Secrets Manager ARN for the RDS-managed master user secret."
  value       = module.database.db_master_user_secret_arn
}

output "cloudwatch_postgresql_log_group_name" {
  description = "CloudWatch PostgreSQL log group name."
  value       = module.database.cloudwatch_postgresql_log_group_name
}

output "ecs_cluster_name" {
  description = "ECS cluster name."
  value       = module.ecs_api.ecs_cluster_name
}

output "api_service_name" {
  description = "ECS API service name."
  value       = module.ecs_api.api_service_name
}

output "api_task_definition_arn" {
  description = "API task definition ARN."
  value       = module.ecs_api.api_task_definition_arn
}

output "api_log_group_name" {
  description = "CloudWatch log group name for the API container."
  value       = module.ecs_api.api_log_group_name
}

output "api_container_name" {
  description = "API container name."
  value       = module.ecs_api.api_container_name
}

output "api_container_image" {
  description = "Full API container image."
  value       = module.ecs_api.api_container_image
}

output "task_execution_role_arn" {
  description = "ECS task execution role ARN."
  value       = module.ecs_api.task_execution_role_arn
}

output "task_role_arn" {
  description = "ECS task role ARN."
  value       = module.ecs_api.task_role_arn
}