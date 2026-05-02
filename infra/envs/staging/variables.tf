variable "aws_region" {
  description = "AWS region for staging."
  type        = string
  default     = "eu-west-2"
}

variable "org_slug" {
  description = "Lowercase organisation slug used in resource names."
  type        = string
  default     = "cloud-dash"
}

variable "project_slug" {
  description = "Lowercase project slug used in resource names."
  type        = string
  default     = "crudapp-platform"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "staging"
}

variable "owner" {
  description = "Owner tag value."
  type        = string
  default     = "cloud-dash"
}

variable "vpc_cidr" {
  description = "CIDR block for the staging VPC."
  type        = string
  default     = "10.50.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs for the ALB tier."
  type        = list(string)
  default     = ["10.50.0.0/24", "10.50.1.0/24"]
}

variable "private_app_subnet_cidrs" {
  description = "Private subnet CIDRs for the ECS app tier."
  type        = list(string)
  default     = ["10.50.10.0/24", "10.50.11.0/24"]
}

variable "private_data_subnet_cidrs" {
  description = "Private subnet CIDRs for the RDS data tier."
  type        = list(string)
  default     = ["10.50.20.0/24", "10.50.21.0/24"]
}

variable "db_name" {
  description = "Initial staging database name."
  type        = string
  default     = "crudapp"
}

variable "db_master_username" {
  description = "RDS master username. Password is managed by RDS and Secrets Manager."
  type        = string
  default     = "crudappadmin"
}

variable "db_engine_version" {
  description = "PostgreSQL major version for staging."
  type        = string
  default     = "16"
}

variable "db_parameter_group_family" {
  description = "PostgreSQL parameter group family for staging."
  type        = string
  default     = "postgres16"
}

variable "db_instance_class" {
  description = "Small staging RDS instance class."
  type        = string
  default     = "db.t4g.micro"
}

variable "api_image_tag" {
  description = "ECR image tag to deploy, for example step7-abc1234."
  type        = string
}

variable "api_container_port" {
  description = "FastAPI container port."
  type        = number
  default     = 8080
}

variable "api_cpu" {
  description = "Fargate CPU units for the API task."
  type        = number
  default     = 256
}

variable "api_memory" {
  description = "Fargate memory in MiB for the API task."
  type        = number
  default     = 512
}

variable "api_desired_count" {
  description = "API service desired task count."
  type        = number
  default     = 1
}

variable "api_log_retention_days" {
  description = "CloudWatch log retention in days for API logs."
  type        = number
  default     = 7
}

variable "fargate_platform_version" {
  description = "Fargate platform version for the API service."
  type        = string
  default     = "1.4.0"
}

variable "domain_name" {
  description = "Base public domain name."
  type        = string
  default     = "awsclouddash.click"
}

variable "app_subdomain" {
  description = "Subdomain for the staging API."
  type        = string
  default     = "staging"
}

variable "alb_access_log_retention_days" {
  description = "Retention period for ALB access logs."
  type        = number
  default     = 30
}

variable "allow_force_destroy_alb_logs" {
  description = "Only set true for cleanup if you want Terraform to delete a non-empty ALB log bucket."
  type        = bool
  default     = false
}
variable "alert_email" {
  description = "Optional email address for CloudWatch alarm notifications. Leave empty to disable email alerts."
  type        = string
  default     = ""
}

variable "alb_5xx_threshold" {
  description = "ALB target 5XX count threshold."
  type        = number
  default     = 5
}

variable "alb_response_time_threshold_seconds" {
  description = "ALB average target response time threshold in seconds."
  type        = number
  default     = 1
}

variable "ecs_cpu_threshold" {
  description = "ECS CPU utilization alarm threshold percentage."
  type        = number
  default     = 80
}

variable "ecs_memory_threshold" {
  description = "ECS memory utilization alarm threshold percentage."
  type        = number
  default     = 80
}

variable "rds_cpu_threshold" {
  description = "RDS CPU utilization alarm threshold percentage."
  type        = number
  default     = 80
}

variable "rds_free_storage_threshold_bytes" {
  description = "RDS free storage threshold in bytes."
  type        = number
  default     = 2147483648
}


variable "waf_rate_limit" {
  description = "Maximum requests from a single IP in a 5-minute period. Step 11 starts in count mode."
  type        = number
  default     = 2000
}

variable "ecs_autoscaling_min_capacity" {
  description = "Minimum ECS task count for staging autoscaling."
  type        = number
  default     = 1
}

variable "ecs_autoscaling_max_capacity" {
  description = "Maximum ECS task count for staging autoscaling."
  type        = number
  default     = 2
}

variable "ecs_autoscaling_cpu_target" {
  description = "Target average ECS CPU utilization percentage."
  type        = number
  default     = 60
}

variable "ecs_autoscaling_memory_target" {
  description = "Target average ECS memory utilization percentage."
  type        = number
  default     = 70
}

variable "backup_schedule" {
  description = "AWS Backup daily schedule. Default is 02:00 UTC."
  type        = string
  default     = "cron(0 2 * * ? *)"
}

variable "backup_delete_after_days" {
  description = "Delete AWS Backup recovery points after this many days."
  type        = number
  default     = 14
}

