resource "null_resource" "cmd" {
  provisioner "local-exec" {
    command = "aws route53 list-hosted-zones-by-name > ./templates/zones.tpl"
  }
}

data "aws_route53_zone" "website" {
  name         = local.apex_zone
  private_zone = false
}

resource "aws_acm_certificate" "ssl" {
  depends_on        = [data.aws_route53_zone.website]
  domain_name       = data.aws_route53_zone.website.name
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "dns" {
  certificate_arn         = aws_acm_certificate.ssl.arn
  validation_record_fqdns = [for record in aws_route53_record.valid : record.fqdn]
}

resource "aws_route53_record" "valid" {
  for_each = {
    for dvo in aws_acm_certificate.ssl.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = dvo.domain_name
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.website.zone_id
}

resource "aws_route53_record" "lb_dns" {
  zone_id         = data.aws_route53_zone.website.zone_id
  name            = data.aws_route53_zone.website.name
  type            = "A"
  allow_overwrite = true

  alias {
    zone_id                = data.aws_lb.pod.zone_id
    name                   = data.aws_lb.pod.dns_name
    evaluate_target_health = true
  }
}

resource "time_sleep" "dns" {
  depends_on      = [aws_route53_record.valid]
  create_duration = "90s"
}