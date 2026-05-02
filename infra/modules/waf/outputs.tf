output "web_acl_name" {
  description = "WAF Web ACL name."
  value       = aws_wafv2_web_acl.this.name
}

output "web_acl_arn" {
  description = "WAF Web ACL ARN."
  value       = aws_wafv2_web_acl.this.arn
}

output "web_acl_id" {
  description = "WAF Web ACL ID."
  value       = aws_wafv2_web_acl.this.id
}

output "association_resource_arn" {
  description = "ALB ARN associated with WAF."
  value       = aws_wafv2_web_acl_association.alb.resource_arn
}

output "waf_mode" {
  description = "Initial WAF rollout mode."
  value       = "count"
}