FROM php:7.1-apache-stretch

ADD root/ /
USER root
# Fix the original permissions of /tmp, the PHP default upload tmp dir.
RUN chmod 777 /tmp && chmod +t /tmp

# Setup the required extensions.
ARG DEBIAN_FRONTEND=noninteractive
RUN /tmp/setup/php-extensions.sh
RUN /tmp/setup/oci8-extension.sh
ENV LD_LIBRARY_PATH /usr/local/instantclient_12_1/
RUN apt-get -y update && apt-get -y install nano git apt-utils sudo wget unzip

VOLUME ["/var/www/moodledata"]

WORKDIR /var/www

RUN mkdir -p /var/www/moodledata && \
    /bin/bash -c 'chmod 777 -R /var/www/moodledata' && \
    /bin/bash -c 'chown www-data /var/www/ -R' && \
    cd /tmp && \
    wget https://github.com/CTIGuarulhos/moodle-ifsp/archive/moodle-branch-3.7+.zip -O moodle.zip && \    
    unzip moodle.zip && \
    cp -pr /tmp/moodle-ifsp-moodle-branch-3.7-/* /var/www/html/ && \
    chown -R www-data:www-data /var/www/moodledata && \
    chmod -R 777 /var/www/moodledata     

EXPOSE 80
EXPOSE 443
