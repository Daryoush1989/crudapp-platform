variable "name_prefix" {
  description = "Name prefix used for database resources."
  type        = string
}

variable "environment" {
  description = "Environment name, for example staging or prod."
  type        = string
}

variable "private_data_subnet_ids" {
  description = "Private data subnet IDs for the RDS subnet group."
  type        = list(string)
}

variable "db_security_group_id" {
  description = "Security group ID for the RDS database."
  type        = string
}

variable "db_name" {
  description = "Initial database name."
  type        = string
  default     = "crudapp"
}

variable "master_username" {
  description = "RDS master username. Password is managed by RDS and Secrets Manager."
  type        = string
  default     = "crudappadmin"
}

variable "engine_version" {
  description = "PostgreSQL major version."
  type        = string
  default     = "16"
}

variable "parameter_group_family" {
  description = "PostgreSQL parameter group family."
  type        = string
  default     = "postgres16"
}

variable "instance_class" {
  description = "RDS instance class for staging."
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Initial allocated storage in GiB."
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum autoscaled storage in GiB."
  type        = number
  default     = 100
}

variable "backup_retention_period" {
  description = "Backup retention in days."
  type        = number
  default     = 7
}

variable "cloudwatch_log_retention_days" {
  description = "CloudWatch log retention in days."
  type        = number
  default     = 7
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment. Keep false for cost-conscious staging."
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable deletion protection. Use true for production."
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy. For production, set this to false."
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Apply DB changes immediately. For production, prefer false."
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "Optional KMS key ID for storage encryption. Null uses AWS-managed key."
  type        = string
  default     = null
}

variable "maintenance_window" {
  description = "Preferred maintenance window."
  type        = string
  default     = "sun:03:00-sun:04:00"
}

variable "backup_window" {
  description = "Preferred backup window."
  type        = string
  default     = "02:00-03:00"
}

variable "tags" {
  description = "Common tags for resources."
  type        = map(string)
  default     = {}
}