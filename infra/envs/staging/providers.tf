provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      Project     = "crudapp-platform"
      ManagedBy   = "Terraform"
      Owner       = "cloud-dash"
      Repository  = "crudapp-platform"
      Environment = "staging"
    }
  }
}