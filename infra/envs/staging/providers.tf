provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_slug
      ManagedBy   = "Terraform"
      Owner       = var.owner
      Repository  = "crudapp-platform"
      Environment = var.environment
    }
  }
}