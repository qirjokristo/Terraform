data "aws_ami" "ubuntu2004" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
resource "aws_instance" "kristo" {
  
}
resource "aws_launch_template" "kristo" {
    name = "kristo-asg"
  iam_instance_profile {
    
  }
  image_id = data.aws_ami.ubuntu2004
  instance_type = "t3.micro"
  vpc_security_group_ids = aws_security_group.ec2_sg.id
}