locals {
  hosted_zones = jsondecode(file("${path.module}/templates/zones.tpl"))
}
