FROM ubuntu

RUN apt-get update
RUN apt-get install -y apache2
ADD index.html /var/www/html/index.html

EXPOSE 80

RUN ln -s /var/log/apache2 /etc/apache2/logs

ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_LOCK_DIR /var/lock
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR logs

ENTRYPOINT /usr/sbin/apache2 -DFOREGROUND
