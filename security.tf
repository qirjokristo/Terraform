
resource "aws_security_group" "rds_sg" {
  name        = "db_sg"
  description = "Security group for the database"
  vpc_id      = aws_vpc.panamax.id
  tags        = var.common_tags
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_all]
  }
}

resource "aws_security_group_rule" "ingress_rds_eks" {
  type                     = "ingress"
  security_group_id        = aws_security_group.rds_sg.id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  description              = "Allow connection between database and cluster"
  source_security_group_id = aws_eks_cluster.panamax.vpc_config[0].cluster_security_group_id
}