output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = values(aws_subnet.public)[*].id
}

output "private_app_subnet_ids" {
  description = "Private app subnet IDs."
  value       = values(aws_subnet.private_app)[*].id
}

output "private_data_subnet_ids" {
  description = "Private data subnet IDs."
  value       = values(aws_subnet.private_data)[*].id
}

output "public_route_table_id" {
  description = "Public route table ID."
  value       = aws_route_table.public.id
}

output "private_app_route_table_id" {
  description = "Private app route table ID."
  value       = aws_route_table.private_app.id
}

output "private_data_route_table_id" {
  description = "Private data route table ID."
  value       = aws_route_table.private_data.id
}

output "s3_gateway_endpoint_id" {
  description = "S3 Gateway VPC Endpoint ID."
  value       = aws_vpc_endpoint.s3_gateway.id
}