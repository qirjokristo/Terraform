resource "null_resource" "pod" {
  depends_on = [helm_release.alb, time_sleep.dns]
  provisioner "local-exec" {
    command = "kubectl apply -f ./eks_manifests/2048_test.yaml"
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