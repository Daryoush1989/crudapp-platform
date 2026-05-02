variable "name_prefix" {
  description = "Name prefix used for backup resources."
  type        = string
}

variable "environment" {
  description = "Environment name, for example staging."
  type        = string
}

variable "backup_resource_arns" {
  description = "Resource ARNs protected by this backup plan."
  type        = list(string)
}

variable "backup_schedule" {
  description = "AWS Backup cron schedule."
  type        = string
  default     = "cron(0 2 * * ? *)"
}

variable "start_window_minutes" {
  description = "Minutes after scheduled time that a backup job can start."
  type        = number
  default     = 60
}

variable "completion_window_minutes" {
  description = "Minutes after backup starts that it should complete."
  type        = number
  default     = 180
}

variable "delete_after_days" {
  description = "Delete recovery points after this many days."
  type        = number
  default     = 14
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}