FROM ubuntu 
RUN apt update 
RUN apt install apache2 default-mysql-client php-mbstring php unzip -y
RUN apt clean
RUN rm /var/www/html/*
COPY ./files/* /var/www/html/
RUN unzip /var/www/html/aws.zip
RUN rm /var/www/html/aws.zip
EXPOSE 80
CMD apachectl -D FOREGROUND