variable "name_prefix" {
  description = "Name prefix used for WAF resources."
  type        = string
}

variable "environment" {
  description = "Environment name, for example staging."
  type        = string
}

variable "alb_arn" {
  description = "Application Load Balancer ARN to associate with the WAF Web ACL."
  type        = string
}

variable "rate_limit" {
  description = "Maximum requests from a single IP in a 5-minute period. Initially counted, not blocked."
  type        = number
  default     = 2000
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}