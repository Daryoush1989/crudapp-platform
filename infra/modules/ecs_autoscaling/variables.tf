variable "name_prefix" {
  description = "Name prefix used for autoscaling resources."
  type        = string
}

variable "environment" {
  description = "Environment name, for example staging."
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

variable "min_capacity" {
  description = "Minimum ECS task count."
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum ECS task count."
  type        = number
  default     = 2
}

variable "cpu_target_value" {
  description = "Target average ECS CPU utilization percentage."
  type        = number
  default     = 60
}

variable "memory_target_value" {
  description = "Target average ECS memory utilization percentage."
  type        = number
  default     = 70
}

variable "scale_in_cooldown" {
  description = "Cooldown in seconds before scaling in."
  type        = number
  default     = 300
}

variable "scale_out_cooldown" {
  description = "Cooldown in seconds before scaling out."
  type        = number
  default     = 120
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}