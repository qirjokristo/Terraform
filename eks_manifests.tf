resource "null_resource" "acm" {
  depends_on = [helm_release.alb, aws_acm_certificate_validation.dns]
  provisioner "local-exec" {
    command = "sed -i '58 a \\    alb.ingress.kubernetes.io/certificate-arn: ${aws_acm_certificate.ssl.arn}' eks_manifests/panamax-app.yaml"
  }
}

resource "null_resource" "sub" {
  depends_on = [null_resource.acm]
  provisioner "local-exec" {
    command = "sed -i '58 a \\    alb.ingress.kubernetes.io/subnets: ${var.project}_public_subnet_1, ${var.project}_public_subnet_2, ${var.project}_public_subnet_3, ${var.project}_public_subnet_4, ${var.project}_public_subnet_5' eks_manifests/panamax-app.yaml"
  }
}

resource "null_resource" "pod" {
  depends_on = [helm_release.alb, null_resource.sub]
  provisioner "local-exec" {
    command = "kubectl apply -f ./eks_manifests/panamax-app.yaml"
  }
}

resource "time_sleep" "ingress" {
  depends_on      = [null_resource.pod]
  create_duration = "30s"
}

data "aws_lb" "pod" {
  depends_on = [time_sleep.ingress]
  tags = {
    author = "Kristo"
  }
}
