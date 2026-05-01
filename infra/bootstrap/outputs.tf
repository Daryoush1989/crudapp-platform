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
output "staging_actions_deploy_role_arn" {
  description = "IAM role ARN assumed by GitHub Actions for staging deployments."
  value       = module.actions_deploy.role_arn
}

output "staging_actions_oidc_subject" {
  description = "GitHub OIDC subject allowed to assume the staging deployment role."
  value       = module.actions_deploy.oidc_subject
}

