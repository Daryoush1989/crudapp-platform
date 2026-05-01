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
  description = "Public subnet IDs for ALB."
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

output "alb_security_group_id" {
  description = "ALB security group ID."
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

output "db_address" {
  description = "RDS DB address."
  value       = module.database.db_address
}

output "db_endpoint" {
  description = "RDS DB endpoint."
  value       = module.database.db_endpoint
}

output "db_name" {
  description = "Database name."
  value       = module.database.db_name
}

output "db_master_user_secret_arn" {
  description = "Secrets Manager ARN for the RDS-managed master user secret."
  value       = module.database.db_master_user_secret_arn
}

output "interface_endpoint_ids" {
  description = "Interface endpoint IDs used by private ECS runtime."
  value       = module.vpc_endpoints.interface_endpoint_ids
}

output "ecs_cluster_name" {
  description = "ECS cluster name."
  value       = module.ecs_api.ecs_cluster_name
}

output "api_service_name" {
  description = "API ECS service name."
  value       = module.ecs_api.api_service_name
}

output "api_task_definition_arn" {
  description = "API task definition ARN."
  value       = module.ecs_api.api_task_definition_arn
}

output "api_log_group_name" {
  description = "CloudWatch log group for API container logs."
  value       = module.ecs_api.api_log_group_name
}

output "api_container_image" {
  description = "Container image deployed by the API task definition."
  value       = local.api_container_image
}

output "api_container_name" {
  description = "API container name."
  value       = module.ecs_api.api_container_name
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN."
  value       = module.acm.certificate_arn
}

output "alb_name" {
  description = "Application Load Balancer name."
  value       = module.alb.alb_name
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name."
  value       = module.alb.alb_dns_name
}

output "api_target_group_arn" {
  description = "API target group ARN."
  value       = module.alb.api_target_group_arn
}

output "api_target_group_name" {
  description = "API target group name."
  value       = module.alb.api_target_group_name
}

output "public_app_url" {
  description = "Public HTTPS URL for the staging app."
  value       = "https://${module.dns.fqdn}"
}

output "route53_record_name" {
  description = "Route 53 public record."
  value       = module.dns.fqdn
}

output "alb_access_logs_bucket_name" {
  description = "S3 bucket for ALB access logs."
  value       = module.alb_logs.bucket_name
}