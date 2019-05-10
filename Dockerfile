FROM php:7.1-apache-stretch

ADD root/ /
# Fix the original permissions of /tmp, the PHP default upload tmp dir.
RUN chmod 777 /tmp && chmod +t /tmp

# Setup the required extensions.
ARG DEBIAN_FRONTEND=noninteractive
RUN /tmp/setup/php-extensions.sh
RUN /tmp/setup/oci8-extension.sh
ENV LD_LIBRARY_PATH /usr/local/instantclient
 
RUN mkdir -p /var/www/moodledata && \
    chown www-data /var/www/ -R

