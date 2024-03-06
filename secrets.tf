resource "aws_secretsmanager_secret" "rds" {
  name        = "rdssecret"
  description = "Secret for db credentials"
  tags        = var.common_tags
}

resource "aws_secretsmanager_secret_version" "rds" {
  depends_on = [ aws_db_instance.terra ]
  secret_id     = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode({
    username              = var.db_user,
    password              = random_password.rds.result,
    host                  = aws_db_instance.terra.address,
    dbClusterIdentifier  = "kristo-test"
  })
}
  