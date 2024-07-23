data "aws_iam_policy" "eksworker" {
  name = "AmazonEKSWorkerNodePolicy"
}

data "aws_iam_policy" "eksservice" {
  name = "AmazonEKSWorkerNodePolicy"
}

data "aws_iam_policy" "ekscni" {
  name = "AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role" "eks" {
  name               = "kristo_eks_worker"
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

resource "aws_iam_role_policy_attachment" "eksworker" {
  role = aws_iam_role.eks.name
  policy_arn = data.aws_iam_policy.eksworker.arn
}

resource "aws_iam_role_policy_attachment" "eksservice" {
  role = aws_iam_role.eks.name
  policy_arn = data.aws_iam_policy.eksservice.arn
}

resource "aws_iam_role_policy_attachment" "ekscni" {
  role = aws_iam_role.eks.name
  policy_arn = data.aws_iam_policy.ekscni.arn
}

resource "aws_iam_role_policy" "s3" {
  name   = "s3_admin"
  role   = aws_iam_role.eks.id
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
  role   = aws_iam_role.eks.id
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


resource "aws_iam_instance_profile" "eks" {
  name = "kristo_eks_profile"
  role = aws_iam_role.eks.name
  tags = var.common_tags
}

