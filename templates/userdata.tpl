#!/bin/bash
apt update -y
apt install tasksel php-mbstring unzip awscli -y
tasksel install lamp-server
mysql --host='${db_host}' --user='admin' --password='${password}' --execute "CREATE DATABASE project;
USE project;
CREATE TABLE login (username varchar(10),password varchar(10));
INSERT INTO login VALUES ('kristo','qirjo'),('marko','skendo'),('ardit','shehu');"
aws s3 sync s3://${aws_bucket}/ /var/www/html/
cd /var/www/html/
unzip aws.zip
rm aws.zip
echo "<h3>Instance id:$(curl http://169.254.169.254/latest/meta-data/instance-id)</h3>" >>index.html
systemctl restart apache2