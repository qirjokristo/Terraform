data "aws_iam_role" "ekscontrol" {
  name = "AWSServiceRoleForAmazonEKS"
}

resource "aws_iam_role" "eksworker" {
  
}


resource "aws_iam_role_policy" "s3" {
  name   = "s3_admin"
  role   = data.aws_iam_role.eksworker.id
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
  role   = data.aws_iam_role.eksworker.id
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
