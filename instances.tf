data "aws_ami" "ubuntu2004" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
resource "aws_instance" "planarian" {
  ami                    = data.aws_ami.ubuntu2004.id
  subnet_id              = aws_subnet.pub[0].id
  iam_instance_profile   = aws_iam_instance_profile.ec2.name
  tags                   = merge({ Name = "${var.project}-ec2" }, local.common_tags)
  instance_type          = var.ec2_instance_class
  depends_on             = [aws_s3_object.files, aws_db_instance.planarian]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  root_block_device {
    delete_on_termination = true
  }
  user_data = templatefile("${path.module}/templates/userdata.tpl", {
    db_host    = aws_db_instance.planarian.address
    db_user    = var.db_user
    db_pass    = random_password.rds.result
    aws_bucket = aws_s3_bucket.planarian.id
    }
  )
}

resource "time_sleep" "wait" {
  depends_on      = [aws_instance.planarian]
  create_duration = "4m"

}
resource "aws_ami_from_instance" "planarian" {
  name               = "${var.project}-golden-ami"
  source_instance_id = aws_instance.planarian.id
  depends_on         = [time_sleep.wait]
  tags                   = merge({ Name = "${var.project}-ami" }, local.common_tags)
}


resource "aws_launch_template" "planarian" {
  name = "${var.project}-lt"
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.name
  }
  image_id               = aws_ami_from_instance.planarian.id
  instance_type          = var.ec2_instance_class
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags                   = local.common_tags
  user_data              = filebase64("${path.module}/templates/lt_userdata.tpl")
  tag_specifications {
    resource_type = "instance"
    tags          = local.common_tags
  }
}

resource "aws_autoscaling_group" "planarian" {
  name                      = "${var.project}_asg"
  min_size                  = 1
  max_size                  = length(data.aws_availability_zones.online.names)
  desired_capacity          = 3
  health_check_type         = "ELB"
  health_check_grace_period = 20
  vpc_zone_identifier       = aws_subnet.pub[*].id
  target_group_arns         = [aws_lb_target_group.planarian.arn]
  launch_template {
    id      = aws_launch_template.planarian.id
    version = "$Latest"
  }
}