resource "aws_s3_bucket" "planarian" {
  bucket = lower("${var.project}-project-${random_integer.bucket_name.result}")
  tags   = local.common_tags
}
resource "aws_s3_object" "files" {
  for_each = { for idx, file in var.files : idx => file }

  bucket = aws_s3_bucket.planarian.id
  key    = trimprefix(each.value, "files/")
  source = each.value
  tags   = local.common_tags
}

