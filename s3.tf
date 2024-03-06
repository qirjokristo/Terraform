resource "aws_s3_bucket" "terra" {
  bucket = lower("kristo-project-${random_integer.bucket_name.result}")
  tags   = var.common_tags
}
