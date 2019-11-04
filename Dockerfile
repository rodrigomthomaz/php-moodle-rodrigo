# Forked from TrafeX/docker-php-nginx (https://github.com/TrafeX/docker-php-nginx/)
#TESTE
FROM alpine:3.10
LABEL Maintainer="CTI Guarulhos <ctiguarulhos@ifsp.edu.br>" \
      Description="Docker Image for moodle."

ENV TZ America/Sao_Paulo
ENV DB_HOST moodledb
ENV DB_PORT 5432
ENV DB_DATABASE moodle
ENV DB_USERNAME moodle
ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR.UTF-8
ENV LC_ALL pt_BR.UTF-8
ENV LANG=pt_BR.UTF-8 \
    LANGUAGE=pt_BR.UTF-8

RUN apk --no-cache add tzdata gettext git php7 php7-fpm php7-pdo php7-json php7-openssl php7-curl \
    php7-zlib php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-ctype php7-simplexml php7-zip php7-pgsql \
    php7-mbstring php7-gd php7-xmlwriter php7-tokenizer php7-memcached php7-ftp php7-iconv php7-fileinfo \
    nginx supervisor curl bash nano openssl postgresql-client ca-certificates wget php7-xmlrpc php7-soap php7-opcache && \
    #certbot certbot-nginx jq procps && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-bin-2.25-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-i18n-2.25-r0.apk && \
    apk add glibc-bin-2.25-r0.apk glibc-i18n-2.25-r0.apk glibc-2.25-r0.apk && \
    cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    echo "America/Sao_Paulo" > /etc/timezone && \
    curl -sS https://getcomposer.org/installer \
    | php -- --install-dir=/usr/local/bin --filename=composer && \
    mkdir /moodledata && \
    wget https://github.com/CTIGuarulhos/moodle-ifsp/archive/moodle-branch-3.7+_blocksuap.zip -O /moodle.zip && \
    unzip moodle.zip && \
    rm moodle.zip && \
    mv moodle-ifsp-moodle-branch-3.7-_blocksuap src && \
    apk del git tzdata jq

COPY wait-for-it.sh start.sh locale.md /

RUN chmod u+x /wait-for-it.sh && \
    chmod u+x /start.sh && \
    cat /locale.md | xargs -i /usr/glibc-compat/bin/localedef -i {} -f UTF-8 {}.UTF-8

VOLUME ["/moodledata","/etc/letsencrypt/"]

COPY config/crontab /etc/crontabs/root
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf
COPY config/php.ini /etc/php7/conf.d/zzz_custom.ini
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD chown root:root /etc/crontabs/root && /usr/sbin/crond -f

WORKDIR /src

EXPOSE 80
EXPOSE 443

#ENTRYPOINT /wait-for-it.sh $DB_HOST:$DB_PORT --strict --timeout=120 -- /start.sh
