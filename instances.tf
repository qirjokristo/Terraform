data "aws_ami" "ubuntu2004" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
resource "aws_instance" "kristo" {
  ami                    = data.aws_ami.ubuntu2004.id
  subnet_id              = aws_subnet.pub[0].id
  iam_instance_profile   = aws_iam_instance_profile.kristo.name
  tags                   = merge({ Name = "kristo-ec2" }, var.common_tags)
  instance_type          = "t2.micro"
  depends_on             = [aws_s3_object.file, aws_db_instance.kristo]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  root_block_device {
    delete_on_termination = true
  }
  user_data = templatefile("${path.module}/templates/userdata.tpl", {
    db_host    = aws_db_instance.kristo.address
    db_user    = var.db_user
    db_pass    = random_password.rds.result
    aws_bucket = aws_s3_bucket.kristo.id
    }
  )
}

resource "time_sleep" "wait" {
  depends_on      = [aws_instance.kristo]
  create_duration = "3m"

}
resource "aws_ami_from_instance" "kristo" {
  name               = "kristo-golden-ami"
  source_instance_id = aws_instance.kristo.id
  depends_on         = [time_sleep.wait]
  tags               = var.common_tags
}


resource "aws_launch_template" "kristo" {
  name = "kristo-lt"
  iam_instance_profile {
    name = aws_iam_instance_profile.kristo.name
  }
  image_id               = aws_ami_from_instance.kristo.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags                   = var.common_tags
  user_data              = filebase64("${path.module}/templates/lt_userdata.tpl")
  tag_specifications {
    resource_type = "instance"
    tags          = var.common_tags
  }
}

resource "aws_autoscaling_group" "kristo" {
  name                      = "kristo_asg"
  min_size                  = 1
  max_size                  = length(data.aws_availability_zones.online.names)
  desired_capacity          = 3
  health_check_type         = "ELB"
  health_check_grace_period = 20
  vpc_zone_identifier       = aws_subnet.pub[*].id
  target_group_arns         = [aws_lb_target_group.kristo.arn]
  launch_template {
    id      = aws_launch_template.kristo.id
    version = "$Latest"
  }
}