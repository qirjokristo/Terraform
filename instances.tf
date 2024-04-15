data "aws_ami" "ubuntu2004" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
resource "aws_instance" "kristo" {
  ami                  = data.aws_ami.ubuntu2004.id
  subnet_id            = aws_subnet.pub[0].id
  iam_instance_profile = aws_iam_instance_profile.kristo.name
  tags                 = var.common_tags
  instance_type        = "t3.micro"
  depends_on           = [aws_s3_object.file, aws_db_instance.terra]
  root_block_device {
    delete_on_termination = true
  }
  user_data = templatefile("${path.module}/templates/userdata.tpl", {
    db_host    = aws_db_instance.terra.address
    aws_bucket = aws_s3_bucket.kristo.bucket
    password   = random_password.rds.result
    }
  )




}

resource "time_sleep" "wait" {
  depends_on      = [aws_instance.kristo]
  create_duration = "5m"

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
    name = aws_iam_role.kristo.name
  }
  image_id               = aws_ami_from_instance.kristo.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
}
