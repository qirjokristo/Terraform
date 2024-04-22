locals {
  json1 = substr("${file("${path.module}/templates/zones.tpl")}",25,378)
  zone = jsondecode(local.json1)
}
