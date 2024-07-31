resource "aws_secretsmanager_secret" "tfstate" {
  name        = "kristo-tfstate"
  description = "Secret for the S3 bucket that holds terraform state"
  tags        = var.common_tags
}

resource "aws_secretsmanager_secret_version" "tfstate" {
  depends_on = [aws_s3_bucket.tfstate]
  secret_id  = aws_secretsmanager_secret.tfstate.id
  secret_string = jsonencode({
    bucket_name = aws_s3_bucket.tfstate.bucket
    key         = "tfstates/"
  })
}
  