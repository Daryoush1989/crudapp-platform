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

variable "container_image" {
  description = "Full container image URI including tag."
  type        = string
}

variable "private_app_subnet_ids" {
  description = "Private app subnet IDs for the ECS service."
  type        = list(string)
}

variable "app_security_group_id" {
  description = "Security group ID assigned to ECS tasks."
  type        = string
}

variable "db_host" {
  description = "RDS database hostname."
  type        = string
}

variable "db_port" {
  description = "RDS database port."
  type        = number
  default     = 5432
}

variable "db_name" {
  description = "Database name."
  type        = string
}

variable "db_secret_arn" {
  description = "Secrets Manager ARN for the RDS-managed master user secret."
  type        = string
}

variable "container_port" {
  description = "API container port."
  type        = number
  default     = 8080
}

variable "task_cpu" {
  description = "Fargate task CPU units."
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Fargate task memory in MiB."
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired number of ECS tasks."
  type        = number
  default     = 1
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days."
  type        = number
  default     = 7
}

variable "fargate_platform_version" {
  description = "Fargate platform version."
  type        = string
  default     = "1.4.0"
}

variable "target_group_arn" {
  description = "Optional ALB target group ARN. If null, no load balancer is attached."
  type        = string
  default     = null
}

variable "health_check_grace_period_seconds" {
  description = "Grace period for ECS service health checks when behind an ALB."
  type        = number
  default     = 120
}

variable "tags" {
  description = "Common tags for resources."
  type        = map(string)
  default     = {}
}