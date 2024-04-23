locals {
  json1     = substr(null_resource.json.triggers.contents, 25, 378)
  zone      = jsondecode(local.json1)
  apex_zone = trimsuffix(local.zone.Name, ".")
  website   = "https://${data.aws_route53_zone.website.name}"
}
