variable "name_prefix" {
  description = "Name prefix used for VPC endpoint resources."
  type        = string
}

variable "environment" {
  description = "Environment name, for example staging or prod."
  type        = string
}

variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where interface endpoints are created."
  type        = string
}

variable "private_app_subnet_ids" {
  description = "Private app subnet IDs where interface endpoints are created."
  type        = list(string)
}

variable "app_security_group_id" {
  description = "Application security group allowed to reach the endpoints."
  type        = string
}

variable "tags" {
  description = "Common tags for resources."
  type        = map(string)
  default     = {}
}