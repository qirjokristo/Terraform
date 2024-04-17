resource "random_password" "rds" {
  length  = 24
  special = false
}

resource "random_integer" "bucket_name" {
  min = 10000
  max = 99999
}