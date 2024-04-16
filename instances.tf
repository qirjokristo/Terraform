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
  tags                   = merge({Name = "kristo-ec2"},var.common_tags)
  instance_type          = "t2.micro"
  depends_on             = [aws_s3_object.file, aws_db_instance.terra]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id, aws_security_group.elb_sg.id]
  root_block_device {
    delete_on_termination = true
  }
  user_data = templatefile("${path.module}/templates/userdata.tpl", {
    db_host    = aws_db_instance.terra.address
    aws_bucket = aws_s3_bucket.kristo.id
    password   = random_password.rds.result
    }
  )
}

