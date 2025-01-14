locals {
  website   = "https://${data.aws_route53_zone.website.name}"
  json      = jsondecode(file("${path.module}/templates/zones.tpl"))
  apex_zone = trimsuffix(local.json.HostedZones[0].Name, ".")
  common_tags = {
    author      = "Kristo"
    environment = "Sandbox"
    project     = "${var.project}"
  }
}
