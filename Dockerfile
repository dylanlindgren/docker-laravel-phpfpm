FROM debian:jessie

MAINTAINER "Dylan Lindgren" <dylan.lindgren@gmail.com>

# Install PHP-FPM and popular/laravel required extensions
RUN apt-get update -y && \
    apt-get install -y \
    php5-fpm \
    php5-curl \
    php5-gd \
    php5-geoip \
    php5-imagick \
    php5-imap \
    php5-json \
    php5-ldap \
    php5-mcrypt \
    php5-memcache \
    php5-memcached \
    php5-mongo \
    php5-mssql \
    php5-mysqlnd \
    php5-pgsql \
    php5-redis \
    php5-sqlite \
    php5-xdebug \
    php5-xmlrpc \
    php5-xcache

# Configure PHP-FPM
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/fpm/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini && \
    sed -i "s/display_errors = Off/display_errors = stderr/" /etc/php5/fpm/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 30M/" /etc/php5/fpm/php.ini && \
    sed -i "s/;opcache.enable=0/opcache.enable=0/" /etc/php5/fpm/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf && \
    sed -i '/^listen = /clisten = 9000' /etc/php5/fpm/pool.d/www.conf && \
    sed -i '/^listen.allowed_clients/c;listen.allowed_clients =' /etc/php5/fpm/pool.d/www.conf && \
    sed -i '/^;catch_workers_output/ccatch_workers_output = yes' /etc/php5/fpm/pool.d/www.conf && \
    sed -i '/^;env\[TEMP\] = .*/aenv[DB_PORT_3306_TCP_ADDR] = $DB_PORT_3306_TCP_ADDR' /etc/php5/fpm/pool.d/www.conf

RUN mkdir -p /data
VOLUME ["/data"]

EXPOSE 9000

ENTRYPOINT ["/usr/sbin/php5-fpm", "-F"]
