variable "bucket_name" {
  description = "S3 bucket name for ALB access logs."
  type        = string
}

variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "log_prefix" {
  description = "Prefix used for ALB access logs."
  type        = string
  default     = "alb"
}

variable "log_retention_days" {
  description = "Number of days to retain ALB access logs."
  type        = number
  default     = 30
}

variable "force_destroy" {
  description = "Only set true for learning cleanup if you want Terraform to delete a non-empty log bucket."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}