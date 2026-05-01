output "endpoint_security_group_id" {
  description = "Security group ID used by interface VPC endpoints."
  value       = aws_security_group.endpoints.id
}

output "interface_endpoint_ids" {
  description = "Interface VPC endpoint IDs."
  value       = { for key, endpoint in aws_vpc_endpoint.interface : key => endpoint.id }
}

output "interface_endpoint_dns_entries" {
  description = "DNS entries for interface VPC endpoints."
  value       = { for key, endpoint in aws_vpc_endpoint.interface : key => endpoint.dns_entry }
}