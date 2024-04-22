locals {
  hosted_zones = jsondecode(file("${path.module}/templates/zones.tpl"))
  hosted_name_json = jsonencode(local.hosted_zones.HostedZones) 
  hosted_name = jsondecode(local.hosted_name_json)
}
