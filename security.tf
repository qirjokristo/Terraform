resource "aws_security_group" "elb_sg" {
  name        = "alb_sg"
  description = "Security group for the load balancer"
  vpc_id      = aws_vpc.panamax.id
  tags        = var.common_tags

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_all]
  }
}

resource "aws_security_group" "eks_sg" {
  name        = "cluster_sg"
  description = "Security group for the EKS cluster"
  vpc_id      = aws_vpc.panamax.id
  tags        = merge(var.common_tags, { "kubernetes.io/cluster/panamax-cluster" = "shared" })

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_all]
  }
}

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

resource "aws_security_group_rule" "ingress_elb" {
  type              = "ingress"
  security_group_id = aws_security_group.elb_sg.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  description       = "Allow connection between load balancer and server"
  cidr_blocks       = [var.cidr_all]
}

resource "aws_security_group_rule" "ingress_eks_elb" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eks_sg.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  description              = "Allow connection between load balancer and server"
  source_security_group_id = aws_security_group.elb_sg.id
}

resource "aws_security_group_rule" "ingress_rds_eks" {
  type                     = "ingress"
  security_group_id        = aws_security_group.rds_sg.id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  description              = "Allow connection between database and server"
  source_security_group_id = aws_security_group.eks_sg.id
}

resource "aws_security_group_rule" "ingress_eks_eks" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eks_sg.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  description              = "Allow connection between planes"
  source_security_group_id = aws_security_group.eks_sg.id
}