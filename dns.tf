resource "null_resource" "cmd" {
  provisioner "local-exec" {
    command = "aws route53 list-hosted-zones-by-name | findstr Name > ./templates/zones.tpl"
  }
}
