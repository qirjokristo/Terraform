FROM ubuntu 
RUN apt update 
RUN apt install apache2 default-mysql-client php-mbstring php -y
RUN apt clean
RUN rm /var/www/html/*
COPY ./containerfiles/* /var/www/html/
EXPOSE 80
CMD apachectl -D FOREGROUND