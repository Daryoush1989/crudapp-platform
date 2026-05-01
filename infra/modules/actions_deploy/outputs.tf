output "role_name" {
  description = "GitHub Actions staging deploy IAM role name."
  value       = aws_iam_role.deploy.name
}

output "role_arn" {
  description = "GitHub Actions staging deploy IAM role ARN."
  value       = aws_iam_role.deploy.arn
}

output "oidc_subject" {
  description = "OIDC subject allowed to assume the role."
  value       = local.oidc_subject
}