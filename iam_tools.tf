data "tls_certificate" "oidc" {
  url = aws_eks_cluster.panamax.identity[0].oidc[0].issuer
}


resource "aws_iam_openid_connect_provider" "eks" {
  url             = aws_eks_cluster.panamax.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  tags            = var.common_tags
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
}

resource "aws_iam_role" "alb" {
  name = "AmazonEKSLoadBalancerControllerRole"
  tags = var.common_tags
  assume_role_policy = (templatefile("${path.module}/iam_policies/sts_alb.json", {
    oidc = aws_iam_openid_connect_provider.eks.arn }
  ))
}

resource "aws_iam_policy" "alb" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("iam_policies/alb.json")
}

resource "aws_iam_role_policy_attachment" "A_AICPolicy" {
  policy_arn = aws_iam_policy.alb.arn
  role       = aws_iam_role.alb.name
}