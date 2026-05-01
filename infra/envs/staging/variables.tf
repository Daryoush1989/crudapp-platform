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
  description = "Public subnet CIDRs for the future ALB tier."
  type        = list(string)
  default     = ["10.50.0.0/24", "10.50.1.0/24"]
}

variable "private_app_subnet_cidrs" {
  description = "Private subnet CIDRs for the future ECS app tier."
  type        = list(string)
  default     = ["10.50.10.0/24", "10.50.11.0/24"]
}

variable "private_data_subnet_cidrs" {
  description = "Private subnet CIDRs for the future RDS data tier."
  type        = list(string)
  default     = ["10.50.20.0/24", "10.50.21.0/24"]
}

variable "enable_s3_gateway_endpoint" {
  description = "Create the S3 Gateway endpoint for private route tables."
  type        = bool
  default     = true
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