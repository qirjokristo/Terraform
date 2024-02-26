resource "aws_secretsmanager_secret" "rds" {
  name        = "rdssecret"
  description = "Secret for db credentials"
  tags        = var.common_tags
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id

}