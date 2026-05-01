variable "repository_name" {
  description = "ECR repository name. Slash-separated names are supported, for example cloud-dash/crudapp-platform/api."
  type        = string
}

variable "image_tag_mutability" {
  description = "Use IMMUTABLE for production-style image promotion."
  type        = string
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  description = "Enable image scanning when images are pushed."
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "Only set true during cleanup to delete a non-empty repository."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags for resources."
  type        = map(string)
  default     = {}
}