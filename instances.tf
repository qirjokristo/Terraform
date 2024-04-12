data "aws_ami" "ubuntu2004" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
resource "aws_instance" "kristo" {
  ami                  = data.aws_ami.ubuntu2004.name
  subnet_id = aws_subnet.pub[0].id
  iam_instance_profile = aws_iam_instance_profile.kristo.name
  tags                 = var.common_tags
  instance_type        = "t3.micro"
  depends_on = [ aws_s3_object.file, aws_db_instance.terra ]
  root_block_device {
    delete_on_termination = true
  }
  user_data = <<EOF
  #!/bin/bash
apt-get update -y
apt-get install tasksel -y
tasksel install lamp-server
apt install php-mbstring -y
apt install unzip -y
apt install awscli -y
mysql --host=${aws_db_instance.terra.address} --user=admin --password=adminadmin --execute "CREATE DATABASE project;
USE project;
CREATE TABLE login (username varchar(10),password varchar(10));
INSERT INTO login VALUES ('kristo','qirjo'),('marko','skendo'),('ardit','shehu');
"
aws s3 sync ${aws_s3_bucket.kristo.bucket}/* /var/www/html/
unzip /var/www/html/aws.zip
rm /var/www/html/aws.zip
echo "<h3>Instance id:$(curl http://169.254.169.254/latest/meta-data/instance-id)</h3> >>index.html
systemctl restart apache2

}
EOF
}

