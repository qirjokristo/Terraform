#!/bin/bash
apt update -y
apt install tasksel php-mbstring unzip awscli -y
tasksel install lamp-server
mysql --host='${db_host}' --user='${db_user}' --password='${db_pass}' --execute "CREATE DATABASE project;
USE project;
CREATE TABLE login (username varchar(10),password varchar(10));
INSERT INTO login VALUES ('kristo','qirjo'),('marko','skendo'),('ardit','shehu'),('anxhelo','peto');"
aws s3 sync s3://${aws_bucket}/ /var/www/html/
cd /var/www/html/
unzip aws.zip
rm aws.zip
systemctl restart apache2