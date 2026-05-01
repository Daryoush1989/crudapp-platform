variable "name_prefix" {
  description = "Name prefix used for ECS resources."
  type        = string
}

variable "environment" {
  description = "Environment name, for example staging or prod."
  type        = string
}

variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL for the API image."
  type        = string
}

variable "api_image_tag" {
  description = "Immutable image tag for the API container."
  type        = string
}

variable "private_app_subnet_ids" {
  description = "Private app subnet IDs for ECS Fargate tasks."
  type        = list(string)
}

variable "app_security_group_id" {
  description = "Security group ID for the ECS app tasks."
  type        = string
}

variable "api_container_port" {
  description = "Container port exposed by the FastAPI app."
  type        = number
  default     = 8080
}

variable "api_cpu" {
  description = "Fargate task CPU units."
  type        = number
  default     = 256
}

variable "api_memory" {
  description = "Fargate task memory in MiB."
  type        = number
  default     = 512
}

variable "api_desired_count" {
  description = "Desired number of API tasks."
  type        = number
  default     = 0
}

variable "api_log_retention_days" {
  description = "CloudWatch log retention in days."
  type        = number
  default     = 7
}

variable "fargate_platform_version" {
  description = "Fargate platform version."
  type        = string
  default     = "1.4.0"
}

variable "db_host" {
  description = "RDS PostgreSQL host address."
  type        = string
}

variable "db_port" {
  description = "RDS PostgreSQL port."
  type        = number
  default     = 5432
}

variable "db_name" {
  description = "Database name."
  type        = string
}

variable "db_master_user_secret_arn" {
  description = "Secrets Manager ARN for the RDS-managed master user secret."
  type        = string
}

variable "enable_container_insights" {
  description = "Enable ECS Container Insights. Keep false for cost-conscious staging."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags for resources."
  type        = map(string)
  default     = {}
}