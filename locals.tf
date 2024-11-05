locals {
  website   = "https://${data.aws_route53_zone.panamax.name}"
  json      = jsondecode(file("${path.module}/templates/zones.tpl"))
  apex_zone = trimsuffix(local.json.HostedZones[0].Name, ".")
}
