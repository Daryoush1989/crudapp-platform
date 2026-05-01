output "fqdn" {
  description = "Public application FQDN."
  value       = aws_route53_record.app.fqdn
}

output "record_name" {
  description = "Route 53 record name."
  value       = aws_route53_record.app.name
}

output "hosted_zone_id" {
  description = "Route 53 hosted zone ID."
  value       = data.aws_route53_zone.public.zone_id
}