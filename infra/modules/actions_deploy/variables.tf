variable "name_prefix" {
  description = "Name prefix for IAM resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "staging"
}

variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "eu-west-2"
}

variable "github_repository" {
  description = "GitHub repository allowed to assume the role, for example Daryoush1989/crudapp-platform."
  type        = string
}

variable "github_environment" {
  description = "GitHub environment name used in the OIDC subject."
  type        = string
  default     = "staging"
}

variable "ecr_repository_name" {
  description = "ECR repository name, for example cloud-dash/crudapp-platform/api."
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name."
  type        = string
  default     = "cloud-dash-crudapp-platform-staging-ecs-cluster"
}

variable "ecs_service_name" {
  description = "ECS service name."
  type        = string
  default     = "cloud-dash-crudapp-platform-staging-api-service"
}

variable "ecs_task_family" {
  description = "ECS task definition family."
  type        = string
  default     = "cloud-dash-crudapp-platform-staging-api"
}

variable "ecs_execution_role_name" {
  description = "ECS task execution role name."
  type        = string
  default     = "cloud-dash-crudapp-platform-staging-ecs-execution-role"
}

variable "ecs_task_role_name" {
  description = "ECS task role name."
  type        = string
  default     = "cloud-dash-crudapp-platform-staging-ecs-task-role"
}

variable "api_log_group_name" {
  description = "CloudWatch log group for ECS API logs."
  type        = string
  default     = "/ecs/cloud-dash-crudapp-platform/staging/api"
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}