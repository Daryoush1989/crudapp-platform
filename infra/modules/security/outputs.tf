output "alb_security_group_id" {
  description = "ALB security group ID."
  value       = aws_security_group.alb.id
}

output "app_security_group_id" {
  description = "App security group ID."
  value       = aws_security_group.app.id
}

output "db_security_group_id" {
  description = "Database security group ID."
  value       = aws_security_group.db.id
}

output "endpoints_security_group_id" {
  description = "Interface endpoints security group ID."
  value       = aws_security_group.endpoints.id
}