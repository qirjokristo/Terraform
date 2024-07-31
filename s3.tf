resource "aws_s3_bucket" "tfstate" {
  bucket = lower("kristo-tfstates-${random_integer.bucket_name.result}")
  tags   = var.common_tags
}