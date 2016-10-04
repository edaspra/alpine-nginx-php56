# alpine-nginx-php56

A Docker image for running [Nginx] with PHP v.5.6.x, based on Alpine Linux. Also added is bash. For PHP, it can do both MySql and Mongo connectivity.

## Features

This image features:

- [Alpine Linux][alpinelinux]
- [Nginx][nginx]
- [PHP5][php5]

## Versions

- `1.0.0`, `latest` [(Dockerfile)](https://github.com/edaspra/alpine-nginx-php56/blob/master/Dockerfile)


## Usage

To use this image include `FROM edaspra/alpine-nginx-php56` at the top of your `Dockerfile`, or simply `docker run -p 80:80 -p 443:443 --name nginx edaspra/alpine-nginx-php56`.

You have the options to mount your volumes to /etc/nginx/sites-enabled for additional vhost entry if you require one, and /web/www/html for your application folder.

Nginx logs (access and error logs) aren't automatically streamed to `stdout` and `stderr`. To review the logs, you can do one of two things:

Run the following in another terminal window:

```
docker exec -i nginx tail -f /var/log/nginx/access.log -f /var/log/nginx/error.log
```

or, in your `Dockerfile` symlink the Nginx logs to `stdout` and `stderr`:

```
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log
```

## Customisation

This container comes setup as follows:

- Nginx and PHP-FPM will be automatically started for you.
- If Nginx dies, so will the container.

### PHP Info

To check on the PHP configuration, you can access it thru: <container IP/hostname>/info.php. To remove this, comment the following line in `run.sh`.

```
echo "<?php echo phpinfo(); ?>" > /var/www/localhost/htdocs/info.php
```

### Nginx configuration

A basic Nginx configuration is supplied with this image. However, it's easy to overwrite:

- Create your own `nginx.conf`.
- In your `Dockerfile`, make sure your `nginx.conf` file is copied to `/etc/nginx/nginx.conf`.
- Also, you can create multiple vhosts. `/etc/nginx/sites-enabled` is the exposed volume to contain the vhosts, while `/web/www/html` shall hold the application files. 

### Nginx crash

By default, if Nginx crashes, the container will not stop. 


# start nginx
nginx



### PHP-FPM crash

By default, if PHP-FPM crashes, the container will not stop. 


# start php-fpm
php-fpm




