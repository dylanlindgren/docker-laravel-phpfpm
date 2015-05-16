#!/bin/bash

if [ "$XDEBUG_ENABLED" = true ]; then
    cat /opt/etc/xdebug.ini >> /etc/php5/fpm/conf.d/20-xdebug.ini
fi

exec /usr/sbin/php5-fpm -F
