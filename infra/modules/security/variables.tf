variable "name_prefix" {
  description = "Name prefix used for security resources."
  type        = string
}

variable "environment" {
  description = "Environment name, for example staging or prod."
  type        = string
  default     = "staging"
}

variable "vpc_id" {
  description = "VPC ID where security groups are created."
  type        = string
}

variable "app_port" {
  description = "Application container port."
  type        = number
  default     = 8080
}

variable "db_port" {
  description = "PostgreSQL database port."
  type        = number
  default     = 5432
}

variable "tags" {
  description = "Common tags for resources."
  type        = map(string)
  default     = {}
}