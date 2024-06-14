locals {
  json1     = substr(file("${path.module}/templates/zones.tpl"), 25, 369)
  zone      = jsondecode(local.json1)
  apex_zone = trimsuffix(local.zone.Name, ".")
  website   = "https://${data.aws_route53_zone.website.name}"
}
