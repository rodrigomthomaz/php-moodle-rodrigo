FROM php:7.1-apache-stretch
  
ADD root/ /
# Fix the original permissions of /tmp, the PHP default upload tmp dir.
RUN chmod 777 /tmp && chmod +t /tmp

# Setup the required extensions.
ARG DEBIAN_FRONTEND=noninteractive
RUN /tmp/setup/php-extensions.sh
RUN /tmp/setup/oci8-extension.sh
ENV LD_LIBRARY_PATH /usr/local/instantclient_12_1/
RUN apt-get -y update && apt-get -y install nano git apt-utils sudo

VOLUME ["/var/www/moodledata"]

WORKDIR /var/www

RUN mkdir -p /var/www/moodledata && \
    /bin/bash -c 'chmod 777 -R /var/www/moodledata' && \
    /bin/bash -c 'chown www-data /var/www/ -R' && \
    #chown www-data /var/www/ -R
    cd /tmp && \
    git clone -b MOODLE_36_STABLE git://git.moodle.org/moodle.git --depth=1 && \
    #git clone -b moodle-branch01 https://github.com/rodrigomthomaz/moodle-ifsp.git moodle && \
    #wget https://github.com/rodrigomthomaz/moodle-ifsp/archive/moodle-branch01.zip -O moodle.zip 
    #cd /tmp && \
    #unzip moodle.zip && \
    #mv /tmp/moodle-ifsp-moodle-branch01/* /var/www/html/ 
    mv /tmp/moodle/* /var/www/html/ && \
    #rm -rf /tmp/moodle*
    chown -R www-data:www-data /var/www/ && \
    #rm /var/www/html/index.html && \
    #chown www-data. /var/www/ -R
    chmod -R 777 /var/www
    
CMD /bin/sleep 30 && \
    /usr/bin/sudo -u www-data /usr/local/bin/php /var/www/html/admin/cli/install.php --lang="pt_br" --dbtype="$MOODLE_DOCKER_DBTYPE" --dbhost="$MOODLE_DOCKER_DBHOST" --dbuser="$MOODLE_DOCKER_DBUSER" --dbpass="$MOODLE_DOCKER_DBPASS" --dbname="$MOODLE_DOCKER_DBNAME" --wwwroot="$MOODLE_DOCKER_WWWROOT" --fullname="$MOODLE_DOCKER_FULLNAME" --shortname="$MOODLE_DOCKER_SHORTNAME" --adminpass="$MOODLE_DOCKER_ADMINPASS" --non-interactive --agree-license
    #/usr/bin/sudo -u www-data /usr/local/bin/php /var/www/html/admin/cli/install_database.php --agree-license
EXPOSE 80
EXPOSE 443

#RUN apt-get remove git --purge

#CMD /bin/echo "AGUARDANDO DB" && \
#     /bin/sleep 120 && \
#    /bin/echo "CONFIGURANDO MOODLE" && \
#    /usr/bin/sudo -u www-data /usr/local/bin/php /var/www/html/admin/cli/install.php --lang="pt_br" --dbtype="$MOODLE_DOCKER_DBTYPE" --dbhost="$MOODLE_DOCKER_DBHOST" --dbuser="$MOODLE_DOCKER_DBUSER" --dbpass="$MOODLE_DOCKER_DBPASS" --#dbname="$MOODLE_DOCKER_DBNAME" --wwwroot="$MOODLE_DOCKER_WWWROOT" --fullname="$MOODLE_DOCKER_FULLNAME" --shortname="$MOODLE_DOCKER_SHORTNAME" --adminpass="$MOODLE_DOCKER_ADMINPASS" --non-interactive --agree-license 
#    /bin/echo "ATUALIZANDO MOODLE" && \
#    /usr/bin/sudo -u www-data /usr/local/bin/php /var/www/html/admin/cli/install_database.php --agree-license
