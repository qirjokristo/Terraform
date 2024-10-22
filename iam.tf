data "aws_iam_policy" "ekscontrol" {
  name = "AmazonEKSClusterPolicy"
}

data "aws_iam_policy" "eksservice" {
  name = "AmazonEKSServicePolicy"
}

data "aws_iam_policy" "eksvpc" {
  name = "AmazonEKSVPCResourceController"
}

data "aws_iam_policy" "ekscni" {
  name = "AmazonEKS_CNI_Policy"
}

data "aws_iam_policy" "eksworker" {
  name = "AmazonEKSWorkerNodePolicy"
}

data "aws_iam_policy" "eksecrread" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy" "ebsdriver" {
  name = "AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_role" "ekscontrol" {
  name               = "KristoEKSControlRole"
  tags               = var.common_tags
  assume_role_policy = file("${path.module}/iam_policies/sts_eks.json")

}

resource "aws_iam_role" "eksworker" {
  name               = "KristoEKSWorkerRole"
  tags               = var.common_tags
  assume_role_policy = file("${path.module}/iam_policies/sts_ec2.json")

}

# resource "aws_iam_role_policy" "s3" {
#   name = "s3_admin"
#   role = aws_iam_role.eksworker.id
#   policy = (templatefile("${path.module}/iam_policies/s3.json", {
#     bucket = aws_s3_bucket.kristo.arn }
#   ))
# }

resource "aws_iam_role_policy" "secret" {
  name = "secret_retrieve"
  role = aws_iam_role.eksworker.id
  policy = (templatefile("${path.module}/iam_policies/secret.json", {
    secret = aws_secretsmanager_secret.rds.arn }
  ))
}

resource "aws_iam_role_policy_attachment" "C_ClusterPolicy" {
  policy_arn = data.aws_iam_policy.ekscontrol.arn
  role       = aws_iam_role.ekscontrol.name
}

resource "aws_iam_role_policy_attachment" "C_VPCResourceController" {
  policy_arn = data.aws_iam_policy.eksvpc.arn
  role       = aws_iam_role.ekscontrol.name
}

resource "aws_iam_role_policy_attachment" "C_ServicePolicy" {
  policy_arn = data.aws_iam_policy.eksservice.arn
  role       = aws_iam_role.ekscontrol.name
}

resource "aws_iam_role_policy_attachment" "W_NodePolicy" {
  policy_arn = data.aws_iam_policy.eksworker.arn
  role       = aws_iam_role.eksworker.name
}

resource "aws_iam_role_policy_attachment" "W_CNI_Policy" {
  policy_arn = data.aws_iam_policy.ekscni.arn
  role       = aws_iam_role.eksworker.name
}

resource "aws_iam_role_policy_attachment" "W_EC2ContainerRegistryReadOnly" {
  policy_arn = data.aws_iam_policy.eksecrread.arn
  role       = aws_iam_role.eksworker.name
}

resource "aws_iam_role_policy_attachment" "W_AmazonEBSCSIDriverPolicy" {
  policy_arn = data.aws_iam_policy.ebsdriver.arn
  role       = aws_iam_role.eksworker.name
}

resource "aws_iam_role_policy_attachment" "W_ALBController" {
  policy_arn = aws_iam_policy.alb.arn
  role       = aws_iam_role.eksworker.name
}

resource "aws_iam_instance_profile" "EKSWorker" {
  name = "EKS_Worker_Instance_Profile"
  role = aws_iam_role.eksworker.name
}