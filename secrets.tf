resource "random_password" "rds" {
  length  = 24
  special = false
}

resource "aws_secretsmanager_secret" "rds" {
  description = "Secret for db credentials"
  tags        = merge(local.common_tags, { Name = "${var.project}-secret" })
}

resource "aws_secretsmanager_secret_version" "rds" {
  depends_on = [aws_db_instance.panamax]
  secret_id  = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode({
    username            = var.db_user,
    password            = random_password.rds.result,
    host                = aws_db_instance.panamax.address,
    dbClusterIdentifier = "${var.project}-db"
    db_name             = aws_db_instance.panamax.db_name
  })
}
  