variable "aws_region" {
  description = "AWS region for staging."
  type        = string
  default     = "eu-west-2"
}

variable "org_slug" {
  description = "Organisation slug."
  type        = string
  default     = "cloud-dash"
}

variable "project_slug" {
  description = "Project slug."
  type        = string
  default     = "crudapp-platform"
}

variable "owner" {
  description = "Owner tag."
  type        = string
  default     = "cloud-dash"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "staging"
}

variable "vpc_cidr" {
  description = "CIDR block for the staging VPC."
  type        = string
  default     = "10.50.0.0/16"
}

variable "azs" {
  description = "Availability Zones for staging."
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs."
  type        = list(string)
  default     = ["10.50.0.0/24", "10.50.1.0/24"]
}

variable "private_app_subnet_cidrs" {
  description = "Private app subnet CIDRs."
  type        = list(string)
  default     = ["10.50.10.0/24", "10.50.11.0/24"]
}

variable "private_data_subnet_cidrs" {
  description = "Private data subnet CIDRs."
  type        = list(string)
  default     = ["10.50.20.0/24", "10.50.21.0/24"]
}