resource "aws_security_group" "elb_sg" {
  name        = "alb_sg"
  description = "Security group for the load balancer"
  vpc_id      = aws_vpc.relic.id
  tags        = var.common_tags

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_all]
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "server_sg"
  description = "Security group for the template in the asg"
  vpc_id      = aws_vpc.relic.id
  tags        = var.common_tags

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
  vpc_id      = aws_vpc.relic.id
  tags        = var.common_tags
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_all]
  }
}


resource "aws_security_group_rule" "ingress_elb_ec2" {
  type                     = "ingress"
  security_group_id        = aws_security_group.elb_sg.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  description              = "Allow connection between load balancer and server"
  source_security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "ingress_ec2_elb" {
  type                     = "ingress"
  security_group_id        = aws_security_group.ec2_sg.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  description              = "Allow connection between load balancer and server"
  source_security_group_id = aws_security_group.elb_sg.id
}

resource "aws_security_group_rule" "ingress_ec2_rds" {
  type                     = "ingress"
  security_group_id        = aws_security_group.ec2_sg.id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  description              = "Allow connection between database and server"
  source_security_group_id = aws_security_group.rds_sg.id
}
resource "aws_security_group_rule" "ingress_rds_ec2" {
  type                     = "ingress"
  security_group_id        = aws_security_group.rds_sg.id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  description              = "Allow connection between database and server"
  source_security_group_id = aws_security_group.ec2_sg.id
}