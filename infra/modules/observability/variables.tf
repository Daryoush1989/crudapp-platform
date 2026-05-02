
variable "name_prefix" {
  description = "Name prefix used for observability resources."
  type        = string
}

variable "environment" {
  description = "Environment name, for example staging."
  type        = string
}

variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "public_app_url" {
  description = "Public application URL."
  type        = string
}

variable "alb_arn_suffix" {
  description = "ALB ARN suffix for CloudWatch metrics."
  type        = string
}

variable "target_group_arn_suffix" {
  description = "Target group ARN suffix for CloudWatch metrics."
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name."
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name."
  type        = string
}

variable "api_log_group_name" {
  description = "CloudWatch log group name for the API container."
  type        = string
}

variable "db_instance_identifier" {
  description = "RDS DB instance identifier."
  type        = string
}

variable "alert_email" {
  description = "Optional email address for alert notifications. Leave empty to disable email subscription."
  type        = string
  default     = ""
}

variable "alb_5xx_threshold" {
  description = "ALB target 5XX count threshold over the evaluation period."
  type        = number
  default     = 5
}

variable "alb_response_time_threshold_seconds" {
  description = "Average target response time threshold in seconds."
  type        = number
  default     = 1
}

variable "ecs_cpu_threshold" {
  description = "ECS service CPU utilization alarm threshold percentage."
  type        = number
  default     = 80
}

variable "ecs_memory_threshold" {
  description = "ECS service memory utilization alarm threshold percentage."
  type        = number
  default     = 80
}

variable "rds_cpu_threshold" {
  description = "RDS CPU utilization alarm threshold percentage."
  type        = number
  default     = 80
}

variable "rds_free_storage_threshold_bytes" {
  description = "RDS free storage alarm threshold in bytes."
  type        = number
  default     = 2147483648
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
