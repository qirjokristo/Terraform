resource "null_resource" "cmd" {
  provisioner "local-exec" {
    command = "aws route53 list-hosted-zones-by-name > ./templates/zones.tpl"
  }
}

data "aws_route53_zone" "website" {
  name = local.hosted_zones.result
  private_zone = false
  depends_on = [ null_resource.cmd ]
}