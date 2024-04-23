resource "null_resource" "cmd" {
  provisioner "local-exec" {
    command = "aws route53 list-hosted-zones-by-name > ./templates/zones.tpl"
  }
}

resource "time_sleep" "zone_fetch" {
  depends_on = [ null_resource.cmd ]
  create_duration = "10s"
}

data "aws_route53_zone" "website" {
  depends_on   = [time_sleep.zone_fetch]
  name         = local.apex_zone
  private_zone = false
}

resource "aws_acm_certificate" "ssl" {
  domain_name       = local.website
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
  name            = local.website
  type            = "A"
  allow_overwrite = true

  alias {
    zone_id                = aws_lb.kristo.zone_id
    name                   = aws_lb.kristo.dns_name
    evaluate_target_health = true
  }
}

resource "time_sleep" "dns" {
  depends_on = [ aws_route53_record.valid ]
  create_duration = "90s"
}