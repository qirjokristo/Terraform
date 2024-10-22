FROM ubuntu 
RUN apt update 
RUN apt install apache2 -y
RUN apt install default-mysql-client -y
RUN apt install php-mbstring -y
RUN apt install -y unzip
RUN apt install -y curl
RUN apt clean
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm awscliv2.zip
RUN rm -rf aws
RUN rm /var/www/html/*
COPY files/* /var/www/html/
RUN unzip /var/www/html/aws.zip
RUN rm /var/www/html/aws.zip
RUN echo "<h3>Instance id:$(curl http://169.254.169.254/latest/meta-data/instance-id)</h3> >>/var/www/html/index.html"
EXPOSE 80
CMD apachectl -D FOREGROUND