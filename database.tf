resource "aws_rds_cluster" "name" {
  
}




resource "aws_rds_cluster_instance" "terra" {
  allocated_storage      = 10
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  username               = var.db_tmp_cred.username
  password               = var.db_tmp_cred.password
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  tags                   = var.common_tags
}