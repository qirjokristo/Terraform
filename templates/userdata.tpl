#!/bin/bash
apt update -y
apt upgrade -y
apt install apache2 mysql-server php php-mbstring unzip awscli -y
mysql --host=${db_host} --user=admin --password=${password} --execute "CREATE DATABASE project;
USE project;
CREATE TABLE login (username varchar(10),password varchar(10));
INSERT INTO login VALUES ('kristo','qirjo'),('marko','skendo'),('ardit','shehu');
"
aws s3 sync ${aws_bucket}/files/* /var/www/html/
unzip /var/www/html/aws.zip
rm /var/www/html/aws.zip
echo "<h3>Instance id:$(curl http://169.254.169.254/latest/meta-data/instance-id)</h3> >>index.html
systemctl restart apache2