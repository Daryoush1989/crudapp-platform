output "alb_arn" {
  description = "ALB ARN."
  value       = aws_lb.this.arn
}

output "alb_name" {
  description = "ALB name."
  value       = aws_lb.this.name
}

output "alb_dns_name" {
  description = "ALB DNS name."
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "ALB canonical hosted zone ID."
  value       = aws_lb.this.zone_id
}

output "api_target_group_arn" {
  description = "API target group ARN."
  value       = aws_lb_target_group.api.arn
}

output "api_target_group_name" {
  description = "API target group name."
  value       = aws_lb_target_group.api.name
}

output "https_listener_arn" {
  description = "HTTPS listener ARN."
  value       = aws_lb_listener.https.arn
}
output "alb_arn_suffix" {
  description = "ALB ARN suffix used for CloudWatch metric dimensions."
  value       = aws_lb.this.arn_suffix
}

output "api_target_group_arn_suffix" {
  description = "Target group ARN suffix used for CloudWatch metric dimensions."
  value       = aws_lb_target_group.api.arn_suffix
}

