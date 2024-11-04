resource "random_password" "rds" {
  length  = 24
  special = false
}