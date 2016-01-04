FROM php:7.0-fpm

MAINTAINER "Zak Henry" <zak.henry@gmail.com>

RUN mkdir -p /data
VOLUME ["/data"]
WORKDIR /data

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libpq-dev \
    libmcrypt-dev

RUN docker-php-ext-install mcrypt pdo_pgsql mbstring pdo_mysql sockets opcache

ENV XDEBUG_VERSION xdebug-2.4.0rc3
RUN cd /tmp && \
    curl -sL -o xdebug.tgz http://xdebug.org/files/$XDEBUG_VERSION.tgz && \
    tar -xvzf xdebug.tgz && \
    cd xdebug* && \
    phpize && \
    ./configure && make && \
    cp modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20151012 && \
    echo 'zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so' >> /usr/local/etc/php/php.ini && \
    rm -rf /tmp/xdebug*



# Configure php
ADD config/memory.ini /opt/etc/memory.ini
ADD config/xdebug.ini /opt/etc/xdebug.ini

RUN sed -i "s|%data-root%|${DATA_ROOT:-/data}|" /opt/etc/xdebug.ini

RUN cat /opt/etc/memory.ini >> /usr/local/etc/php/conf.d/memory.ini


# PHP startup script
ADD config/php-start.sh /opt/bin/php-start.sh
RUN chmod u=rwx /opt/bin/php-start.sh

EXPOSE 9000

ENTRYPOINT ["/opt/bin/php-start.sh"]