variable "aws_region" {
  description = "AWS region for this project."
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

variable "owner" {
  description = "Owner tag value."
  type        = string
  default     = "cloud-dash"
}

variable "allow_force_destroy" {
  description = "Only set true during cleanup to allow Terraform to delete a non-empty state bucket."
  type        = bool
  default     = false
}

variable "allow_force_delete" {
  description = "Only set true during cleanup to allow Terraform to delete a non-empty ECR repository."
  type        = bool
  default     = false
}