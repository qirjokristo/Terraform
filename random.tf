resource "random_password" "rds" {
  length = 12
  special = true
}

resource "random_integer" "bucket_name" {
  min = 1000
  max = 9999
}