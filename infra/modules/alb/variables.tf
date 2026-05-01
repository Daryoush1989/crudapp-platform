variable "load_balancer_name" {
  description = "Short ALB name. Must be 32 characters or fewer."
  type        = string
}

variable "target_group_name" {
  description = "Short target group name. Must be 32 characters or fewer."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the internet-facing ALB."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID for the ALB."
  type        = string
}

variable "container_port" {
  description = "Container port for the API."
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "ALB target group health check path."
  type        = string
  default     = "/health/ready"
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener."
  type        = string
}

variable "access_logs_bucket_name" {
  description = "S3 bucket for ALB access logs."
  type        = string
}

variable "access_logs_prefix" {
  description = "S3 prefix for ALB access logs."
  type        = string
  default     = "alb"
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}