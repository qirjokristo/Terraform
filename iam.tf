data "aws_iam_policy" "ekscluster" {
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

data "aws_iam_policy" "eksnode" {
  name = "AmazonEKSWorkerNodePolicy"
}

data "aws_iam_policy" "eksecrread" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role" "ekscluster" {
  name               = "KristoEKSClusterRole"
  tags               = var.common_tags
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role" "eksnode" {
  name               = "KristoEKSNodeRole"
  tags               = var.common_tags
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}



resource "aws_iam_role_policy" "s3" {
  name   = "s3_admin"
  role   = aws_iam_role.eksnode.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.kristo.arn}",
                "${aws_s3_bucket.kristo.arn}/*"
            ]
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "secret" {
  name   = "secret_retrieve"
  role   = aws_iam_role.eksnode.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
			"Effect": "Allow",
			"Action": [
				"secretsmanager:GetSecretValue"
			],
			"Resource": [
        "${aws_secretsmanager_secret.rds.arn}"
      ]
		}
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "C_ClusterPolicy" {
  policy_arn = data.aws_iam_policy.ekscluster.arn
  role       = aws_iam_role.ekscluster.name
}

resource "aws_iam_role_policy_attachment" "C_VPCResourceController" {
  policy_arn = data.aws_iam_policy.eksvpc.arn
  role       = aws_iam_role.ekscluster.name
}

resource "aws_iam_role_policy_attachment" "C_ServicePolicy" {
  policy_arn = data.aws_iam_policy.eksservice.arn
  role       = aws_iam_role.ekscluster.name
}

resource "aws_iam_role_policy_attachment" "W_NodePolicy" {
  policy_arn = data.aws_iam_policy.eksnode.arn
  role       = aws_iam_role.eksnode.name
}

resource "aws_iam_role_policy_attachment" "W_CNI_Policy" {
  policy_arn = data.aws_iam_policy.ekscni.arn
  role       = aws_iam_role.eksnode.name
}

resource "aws_iam_role_policy_attachment" "W_EC2ContainerRegistryReadOnly" {
  policy_arn = data.aws_iam_policy.eksecrread.arn
  role       = aws_iam_role.eksnode.name
}