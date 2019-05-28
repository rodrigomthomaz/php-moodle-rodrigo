FROM php:7.1-apache-stretch
  
ADD root/ /
# Fix the original permissions of /tmp, the PHP default upload tmp dir.
RUN chmod 777 /tmp && chmod +t /tmp

# Setup the required extensions.
ARG DEBIAN_FRONTEND=noninteractive
RUN /tmp/setup/php-extensions.sh
RUN /tmp/setup/oci8-extension.sh
ENV LD_LIBRARY_PATH /usr/local/instantclient
RUN apt-get -y update && apt-get -y install git nano

VOLUME ["/var/www/moodledata","/var/www/html"]

WORKDIR /var/www

RUN mkdir -p /var/www/moodledata && \
    #/bin/bash -c 'chmod 777 -R /var/www/moodledata' && \
    /bin/bash -c 'chown www-data /var/www/ -R' && \
    cd /tmp && \
    #git clone -b MOODLE_36_STABLE git://git.moodle.org/moodle.git --depth=1 && \
    git clone -b moodle-branch01 https://github.com/rodrigomthomaz/moodle-ifsp.git && \
    mv /tmp/moodle/* /var/www/html/ && \
    #rm /var/www/html/index.html && \
    chown -R www-data. /var/www/html && \
    chown www-data. /var/www/ -R
   # chmod -R 777 /var/www

EXPOSE 80
EXPOSE 443

#RUN apt-get remove git --purge
