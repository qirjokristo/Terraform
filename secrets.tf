resource "aws_secretsmanager_secret" "rds" {
  name        = "panamax-secret"
  description = "Secret for db credentials"
  tags        = var.common_tags
}

resource "aws_secretsmanager_secret_version" "rds" {
  depends_on = [aws_db_instance.panamax]
  secret_id  = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode({
    username            = var.db_user,
    password            = random_password.rds.result,
    host                = aws_db_instance.panamax.address,
    dbClusterIdentifier = "panamax-db"
    db_name             = aws_db_instance.panamax.db_name
  })
}
  