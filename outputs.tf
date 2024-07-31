output "secret_name" {
  value = aws_secretsmanager_secret.tfstate.name
}

output "bucket_name" {
  value = aws_s3_bucket.tfstate.bucket
}