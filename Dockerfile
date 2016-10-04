FROM alpine:latest

MAINTAINER Ed Aspra <edaspra@gmail.com>

RUN mkdir -p /etc/apk && echo "http://alpine.gliderlabs.com/alpine/edge/main" > /etc/apk/repositories &&\
# Install openrc
    apk update && \
#    apk add openrc &&\
# Tell openrc its running inside a container, till now that has meant LXC
#    sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf &&\
# Tell openrc loopback and net are already there, since docker handles the networking
#    echo 'rc_provide="loopback net"' >> /etc/rc.conf &&\
# no need for loggers
#    sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf &&\
# can't get ttys unless you run the container in privileged mode
#    sed -i '/tty/d' /etc/inittab &&\
# can't set hostname since docker sets it
#    sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname &&\
# can't mount tmpfs since not privileged
#    sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh &&\
# can't do cgroups
#    sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh && \
# ensure openssl install to allow wget for SSL
    apk add --update bash && \
    apk add openssl

# Environments
#ENV TIMEZONE            Asia/Jakarta
ENV TIMEZONE            US/Eastern
ENV PHP_MEMORY_LIMIT    512M
ENV MAX_UPLOAD          50M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST        100M

# Let's roll
RUN	apk update && \
	apk upgrade && \
	apk add --update tzdata && \
	cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
	echo "${TIMEZONE}" > /etc/timezone && \
	apk add --update \
                nginx ca-certificates \
                php5-fpm \
		php5-cli \
		php5-mysql \
		php5-json \
		php5-soap \
		php5-mcrypt \
		php5-openssl \
		php5-curl \
		php5-gd \
		php5-apcu \
		php5-iconv \
		php5-dom \
		php5-xmlreader \
		php5-xmlrpc \
		php5-xcache \
		php5-zip \
		php5-pdo_mysql \
		php5-gettext \
		php5-bz2 \
		php5-memcache \
		php5-ctype  && \

    # Set environments
    sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php5/php.ini && \
    sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php5/php.ini && \
    sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|i" /etc/php5/php.ini && \
    sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php5/php.ini && \
    sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php5/php.ini && \
    sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= 0|i" /etc/php5/php.ini && \

    # add sites available inclusion on nginx
    sed -i '/include \/etc\/nginx\/conf\.d*/a include \/etc\/nginx\/sites-enabled\/\*\.conf\;' /etc/nginx/nginx.conf && \
    sed -i 's/user = .*/user = nginx/' /etc/php5/php-fpm.conf && \
    sed -i 's/group = .*/group = www-data/' /etc/php5/php-fpm.conf 

	
VOLUME ["/app","/web","/etc/nginx/sites-enabled","/web/www/html","/run/nginx"]

ADD run.sh /app/run.sh

# fix php-fpm "Error relocating /usr/bin/php-fpm: __flt_rounds: symbol not found" bug
RUN apk add -u musl && \
    rm -rf /var/cache/apk/* && \
    chmod +x /app/run.sh && \ 
    chmod 655 /run/nginx && \
    chown nginx:www-data /run/nginx

EXPOSE 80 443

ENTRYPOINT ["/app/run.sh"]


