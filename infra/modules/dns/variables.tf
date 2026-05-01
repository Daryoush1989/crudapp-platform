variable "domain_name" {
  description = "Base domain name."
  type        = string
}

variable "record_name" {
  description = "Record name, for example staging."
  type        = string
}

variable "alb_dns_name" {
  description = "ALB DNS name."
  type        = string
}

variable "alb_zone_id" {
  description = "ALB hosted zone ID."
  type        = string
}

variable "evaluate_target_health" {
  description = "Evaluate target health for ALB alias."
  type        = bool
  default     = true
}