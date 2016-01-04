#!/bin/bash

if [ "$XDEBUG_ENABLED" = true ]; then
    cat /opt/etc/xdebug.ini >> /usr/local/etc/php/conf.d/xdebug.ini
fi

exec php-fpm
