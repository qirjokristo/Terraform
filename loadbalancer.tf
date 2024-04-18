resource "aws_lb_target_group" "kristo" {
  name     = "kristo-asg-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.relic.id
  stickiness {
    enabled = false
    type    = "lb_cookie"
  }
  health_check {
    enabled = true
  }
  tags = var.common_tags
}

resource "aws_lb" "kristo" {
  name                       = "kristo-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.elb_sg.id]
  subnets                    = aws_subnet.pub[*].id
  enable_deletion_protection = false
  tags                       = var.common_tags
}

resource "aws_lb_listener" "kristo" {
  load_balancer_arn = aws_lb.kristo.arn
  port              = "80"
  protocol          = "HTTP"
  # certificate_arn   = aws_acm_certificate.ssl.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kristo.arn
  }
  tags = var.common_tags
}
