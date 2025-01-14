resource "aws_iam_role" "ec2" {
  name               = "planarian_ec2_role"
  tags               = local.common_tags
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

resource "aws_iam_role" "lambda" {
  name               = "planarian_lambda_role"
  tags               = local.common_tags
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
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
  role   = aws_iam_role.ec2.id
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
                "${aws_s3_bucket.planarian.arn}",
                "${aws_s3_bucket.planarian.arn}/*"
            ]
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "secret" {
  depends_on = [aws_instance.planarian]
  name       = "secret_retrieve"
  role       = aws_iam_role.ec2.id
  policy     = <<EOF
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

resource "aws_iam_role_policy" "lambda" {
  name   = "ec2_terminate"
  role   = aws_iam_role.lambda.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:TerminateInstances"
      ],
      "Effect": "Allow",
      "Resource": [
                "${aws_instance.planarian.arn}"
            ]
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "ec2" {
  name = "planarian_ec2_profile"
  role = aws_iam_role.ec2.name
  tags = local.common_tags
}

