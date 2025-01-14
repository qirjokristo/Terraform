resource "aws_db_subnet_group" "planarian" {
  name       = "${var.project}_rds_sub_gr"
  tags       = local.common_tags
  subnet_ids = aws_subnet.priv[*].id
}

resource "aws_db_instance" "planarian" {
  identifier             = "${var.project}-db"
  allocated_storage      = 10
  engine                 = "mysql"
  instance_class         = var.db_instance_class
  username               = var.db_user
  password               = random_password.rds.result
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  tags                   = local.common_tags
  db_subnet_group_name   = aws_db_subnet_group.planarian.id
  db_name                = "project"
  skip_final_snapshot    = true
}