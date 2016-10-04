#!/bin/bash

## install PHP5-mongo driver upload boot
cd /app
#wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-php5-mongo/master/sgerrand.rsa.pub
#wget https://github.com/sgerrand/alpine-pkg-php5-mongo/releases/download/1.16.4-r0/php5-mongo-1.6.14-r0.apk
#apk add /app/php5-mongo-1.6.14-r0.apk

## add phpinfo() to check server details
#echo "<?php echo phpinfo(); ?>" > /var/www/localhost/htdocs/info.php

# start php-fpm
#mkdir -p /DATA/logs/php-fpm
php-fpm

# start nginx
#mkdir -p /DATA/logs/nginx
#mkdir -p /tmp/nginx
#chown nginx /tmp/nginx
nginx

exec "/bin/bash"
