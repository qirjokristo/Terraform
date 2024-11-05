resource "null_resource" "acm" {
  depends_on = [helm_release.alb, aws_acm_certificate_validation.dns]
  provisioner "local-exec" {
    command = "sed -i '58 a \\    alb.ingress.kubernetes.io/certificate-arn: ${aws_acm_certificate.ssl.arn}' eks_manifests/panamax-app.yaml"
  }
}

resource "null_resource" "pod" {
  depends_on = [helm_release.alb, aws_acm_certificate_validation.dns, null_resource.acm]
  provisioner "local-exec" {
    command = "kubectl apply -f ./eks_manifests/panamax-app.yaml"
  }
}

resource "time_sleep" "ingress" {
  depends_on      = [null_resource.pod]
  create_duration = "30s"
}

resource "aws_eks_pod_identity_association" "panamax" {
  depends_on      = [time_sleep.ingress]
  cluster_name    = aws_eks_cluster.panamax.name
  role_arn        = aws_iam_role.pod.arn
  namespace       = "panamax-app"
  service_account = "panamax"
}

data "aws_lb" "pod" {
  depends_on = [time_sleep.ingress]
  tags = {
    author = "Kristo"
  }
}
