data "aws_route53_zone" "public" {
  name         = var.domain_name
  private_zone = false
}

locals {
  fqdn = "${var.record_name}.${var.domain_name}"
}

resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = local.fqdn
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}