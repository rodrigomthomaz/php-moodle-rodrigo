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
    chmod 777 -R /var/www/moodledata && \
    chown www-data /var/www/ -R && \
    cd /tmp && \
    git clone -b MOODLE_36_STABLE git://git.moodle.org/moodle.git --depth=1 && \
    mv /tmp/moodle/* /var/www/html/ && \
    rm /var/www/html/index.html && \
    chown -R www-data:www-data /var/www/html 
