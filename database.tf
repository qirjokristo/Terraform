resource "aws_db_subnet_group" "rds" {
  name       = "rds subnet group"
  tags       = var.common_tags
  subnet_ids = aws_subnet.priv[*].id
}

resource "aws_db_instance" "panamax" {
  identifier             = "panamax-db"
  allocated_storage      = 10
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  username               = var.db_user
  password               = random_password.rds.result
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  tags                   = var.common_tags
  db_subnet_group_name   = aws_db_subnet_group.rds.id
  db_name = "project"
  skip_final_snapshot    = true
}