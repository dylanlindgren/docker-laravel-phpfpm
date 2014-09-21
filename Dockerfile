FROM centos:centos7

MAINTAINER "Dylan Lindgren" <dylan.lindgren@gmail.com>

# Install required repos, update, and then install PHP-FPM
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-1.noarch.rpm && \ 
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
    yum update -y && \
    yum install --enablerepo=remi -y \
        php-cli \
        php-fpm \
        php-mysqlnd \
        php-mssql \
        php-xml \
        php-pgsql \
        php-gd \
        php-mcrypt \
        php-ldap \
        php-imap \
        php-soap \
        php-mbstring \
        php-pecl-memcache \
        php-pecl-memcached \
        php-pecl-mongo \
        php-pear \
        php-pdo

# Configure and secure PHP
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php-fpm.conf && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php.ini && \
    sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php.ini && \
    sed -i "s/display_errors = Off/display_errors = On" /etc/php.ini && \
    sed -i '/^listen = /clisten = 0.0.0.0:9000' /etc/php-fpm.d/www.conf && \
    sed -i '/^listen.allowed_clients/c;listen.allowed_clients =' /etc/php-fpm.d/www.conf && \
    sed -i '/^;catch_workers_output/ccatch_workers_output = yes' /etc/php-fpm.d/www.conf && \
    sed -i "s/php_admin_flag\[log_errors\] = .*/;php_admin_flag[log_errors] =/" /etc/php-fpm.d/www.conf && \
    sed -i "s/php_admin_value\[error_log\] =.*/;php_admin_value[error_log] =/" /etc/php-fpm.d/www.conf && \
    sed -i "s/php_admin_value\[error_log\] =.*/;php_admin_value[error_log] =/" /etc/php-fpm.d/www.conf && \
    echo "php_admin_value[display_errors] = 'stderr'" >> /etc/php-fpm.d/www.conf

RUN adduser -c "PHP-FPM user" --uid 2000 phpfpm && \
    chown phpfpm -R /var/log/php-fpm /run/php-fpm

# DATA VOLUMES
RUN mkdir -p /data/www
VOLUME ["/data/www"]

# PORTS
# Port 9000 is how Nginx will communicate with PHP-FPM.
EXPOSE 9000

USER phpfpm

# Run PHP-FPM on container start.
ENTRYPOINT ["/usr/sbin/php-fpm", "-F"]
