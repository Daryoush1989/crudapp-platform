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
  description = "Private app subnet IDs for future ECS tasks."
  value       = module.network.private_app_subnet_ids
}

output "private_data_subnet_ids" {
  description = "Private data subnet IDs for future RDS."
  value       = module.network.private_data_subnet_ids
}

output "s3_gateway_endpoint_id" {
  description = "S3 Gateway VPC Endpoint ID."
  value       = module.network.s3_gateway_endpoint_id
}

output "alb_security_group_id" {
  description = "Future ALB security group ID."
  value       = module.security.alb_security_group_id
}

output "app_security_group_id" {
  description = "Future ECS app security group ID."
  value       = module.security.app_security_group_id
}

output "db_security_group_id" {
  description = "Future RDS database security group ID."
  value       = module.security.db_security_group_id
}

output "endpoints_security_group_id" {
  description = "Future interface endpoint security group ID."
  value       = module.security.endpoints_security_group_id
}