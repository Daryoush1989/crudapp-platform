output "aws_account_id" {
  description = "AWS account ID used by this bootstrap stack."
  value       = data.aws_caller_identity.current.account_id
}

output "terraform_state_bucket_name" {
  description = "S3 bucket name for future Terraform remote state."
  value       = aws_s3_bucket.terraform_state.bucket
}

output "ecr_repository_name" {
  description = "ECR repository name for the API image."
  value       = module.ecr_api.repository_name
}

output "ecr_repository_url" {
  description = "Full ECR repository URI for Docker tagging and pushing."
  value       = module.ecr_api.repository_url
}