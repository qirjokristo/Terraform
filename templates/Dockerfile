FROM ubuntu 
RUN apt update 
RUN apt-get install tasksel -y
RUN tasksel install lamp-server
RUN apt install php-mbstring -y
RUN apt install -y unzip
RUN apt install -y awscli
RUN apt clean
RUN mysql --host=database-1.cjmdbfgt4kim.us-east-1.rds.amazonaws.com --user=admin --password=adminadmin --execute "CREATE DATABASE project; USE project; CREATE TABLE login (username varchar(10),password varchar(10)); INSERT INTO login VALUES ('kristo','qirjo'),('marko','skendo'),('ardit','shehu');"
RUN aws s3 sync s3://project.kristo.qirjo/ /var/www/html/
RUN unzip /var/www/html/aws.zip
RUN rm /var/www/html/aws.zip
RUN echo "<h3>Instance id:$(curl http://169.254.169.254/latest/meta-data/instance-id)</h3> >>/var/www/html/index.html
EXPOSE 80
CMD [“apache2”, “-D”, “FOREGROUND”]