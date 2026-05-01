locals {
  endpoint_services = {
    ecr_api = "com.amazonaws.${var.aws_region}.ecr.api"
    ecr_dkr = "com.amazonaws.${var.aws_region}.ecr.dkr"
    logs    = "com.amazonaws.${var.aws_region}.logs"
    secrets = "com.amazonaws.${var.aws_region}.secretsmanager"
  }
}

resource "aws_security_group" "endpoints" {
  name        = "${var.name_prefix}-${var.environment}-interface-endpoints-sg"
  description = "Interface VPC endpoints security group"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-interface-endpoints-sg"
    Tier = "private-endpoints"
  })
}

resource "aws_vpc_security_group_ingress_rule" "endpoints_from_app_https" {
  security_group_id            = aws_security_group.endpoints.id
  description                  = "Allow app tasks to reach interface endpoints over HTTPS"
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
  referenced_security_group_id = var.app_security_group_id
}

resource "aws_vpc_security_group_egress_rule" "endpoints_https_egress" {
  security_group_id = aws_security_group.endpoints.id
  description       = "Allow endpoint return traffic"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_endpoint" "interface" {
  for_each = local.endpoint_services

  vpc_id              = var.vpc_id
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_app_subnet_ids
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-${each.key}-endpoint"
    Tier = "private-endpoints"
  })
}
resource "aws_vpc_security_group_egress_rule" "app_to_interface_endpoints_https" {
  security_group_id            = var.app_security_group_id
  description                  = "Allow app tasks to reach actual interface VPC endpoints over HTTPS"
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
  referenced_security_group_id = aws_security_group.endpoints.id
}

data "aws_prefix_list" "s3" {
  name = "com.amazonaws.${var.aws_region}.s3"
}

resource "aws_vpc_security_group_egress_rule" "app_to_s3_gateway_endpoint_https" {
  security_group_id = var.app_security_group_id
  description       = "Allow app tasks to reach S3 Gateway endpoint for ECR image layers"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  prefix_list_id    = data.aws_prefix_list.s3.id
}
