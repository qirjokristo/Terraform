resource "aws_db_subnet_group" "rds" {
  name       = "rds subnet group"
  tags       = var.common_tags
  subnet_ids = aws_subnet.priv[*].id
}

resource "aws_db_instance" "terra" {
  identifier                  = "kristo-test"
  allocated_storage           = 10
  engine                      = "mysql"
  instance_class              = "db.t3.micro"
  username                    = var.db_user
  manage_master_user_password = true
  vpc_security_group_ids      = [aws_security_group.rds_sg.id]
  tags                        = var.common_tags
  db_subnet_group_name        = aws_db_subnet_group.rds.id
  skip_final_snapshot         = true
}