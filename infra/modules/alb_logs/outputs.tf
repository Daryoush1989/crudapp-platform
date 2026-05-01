output "bucket_name" {
  description = "ALB access logs bucket name."
  value       = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  description = "ALB access logs bucket ARN."
  value       = aws_s3_bucket.this.arn
}

output "log_prefix" {
  description = "ALB access logs prefix."
  value       = var.log_prefix
}