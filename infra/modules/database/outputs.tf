output "db_instance_identifier" {
  description = "RDS DB instance identifier."
  value       = aws_db_instance.this.identifier
}

output "db_instance_arn" {
  description = "RDS DB instance ARN."
  value       = aws_db_instance.this.arn
}

output "db_address" {
  description = "RDS DB address."
  value       = aws_db_instance.this.address
}

output "db_endpoint" {
  description = "RDS DB endpoint."
  value       = aws_db_instance.this.endpoint
}

output "db_port" {
  description = "RDS DB port."
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Database name."
  value       = aws_db_instance.this.db_name
}

output "db_subnet_group_name" {
  description = "DB subnet group name."
  value       = aws_db_subnet_group.this.name
}

output "db_parameter_group_name" {
  description = "DB parameter group name."
  value       = aws_db_parameter_group.this.name
}

output "db_master_user_secret_arn" {
  description = "Secrets Manager ARN for the RDS-managed master user secret."
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}

output "cloudwatch_postgresql_log_group_name" {
  description = "CloudWatch log group for PostgreSQL logs."
  value       = aws_cloudwatch_log_group.postgresql.name
}