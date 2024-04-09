resource "aws_s3_bucket" "kristo" {
  bucket = lower("kristo-project-${random_integer.bucket_name.result}")
  tags   = var.common_tags
}
resource "aws_s3_object" "file" {
  for_each = { for idx, file in var.files : idx => file }

  bucket = aws_s3_bucket.kristo.id
  key    = each.value
  source = each.value
}