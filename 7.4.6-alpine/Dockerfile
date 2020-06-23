FROM alpine:3.12
MAINTAINER Santiago <hrcarsan@gmail.com>

RUN apk update --no-cache \
 ## install dependencies =========================
 && apk add --no-cache --virtual .build-deps \
    openssl \
    openssl-dev \
    curl \
    wget \
    g++ \
    libxml2-dev \
    bzip2-dev \
    curl-dev \
    freetype-dev \
    jpeg-dev \
    libpng-dev \
    gettext-dev \
    libmcrypt-dev \
    readline-dev \
    imap-dev \
    krb5-dev \
    mariadb-dev \
    make \
    autoconf \
    file \
    libc-dev \
    pkgconf \
    re2c \
    gawk \
    sqlite-dev \
    oniguruma-dev \
 ## install php ==================================
 && addgroup -g 82 -S www-data && adduser -u 82 -D -S -G www-data www-data \
 && cd /tmp \
 && export PHP_VERSION=7.4.6 \
 && curl -SL "http://php.net/get/php-$PHP_VERSION.tar.gz/from/this/mirror" -o php-$PHP_VERSION.tar.gz \
 && tar -xzvf php-$PHP_VERSION.tar.gz \
 && cd php-$PHP_VERSION \
 && ./configure \
  --with-config-file-path=/etc/php \
  --with-config-file-scan-dir=/etc/php/conf.d \
  --enable-mbstring \
  --with-curl \
  --with-openssl \
  --with-xmlrpc \
  --enable-soap \
  --enable-zip \
  --with-freetype \
  --with-jpeg \
  --enable-mysqlnd \
  --with-mysql=mysqlnd \
  --with-mysqli=mysqlnd \
  --enable-bcmath \
  --with-bz2 \
  --enable-calendar \
  --enable-exif \
  --enable-ftp \
  --with-gettext \
  --with-imap \
  --with-imap-ssl \
  --with-kerberos \
  --with-mcrypt \
  --enable-pcntl \
  --with-pdo-mysql \
  --with-mhash \
  --with-readline \
  --enable-sockets \
  --enable-sysvmsg \
  --enable-sysvsem \
  --enable-sysvshm \
  --enable-shmop \
  --enable-wddx \
  --with-zlib \
  --enable-fpm \
  --with-fpm-user=www-data \
  --with-fpm-group=www-data \
  --with-pear \
 && make && make install && make clean \
 && mkdir -p /etc/php/conf.d/ \
 && ln -s /usr/local/bin/php /bin/php \
 ## install timezonedb extension =================
 && pecl install timezonedb \
 ## install ioncube extension ===================
 #&& cd /tmp \
 #&& wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
 #&& tar xvfz ioncube_loaders_lin_x86-64.tar.gz \
 #&& cd ioncube \
 #&& mkdir -p /usr/local/lib/php/extensions/no-debug-non-zts-20151012/ \
 #&& cp ioncube_loader_lin_7.0.so /usr/local/lib/php/extensions/no-debug-non-zts-20151012/ \
 # install redis extension =====================
 && pecl install redis
 ## clean ========================================
 #&& runDeps="$( \
		#scanelf --needed --nobanner --recursive /usr/local \
			#| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			#| sort -u \
			#| xargs -r apk info --installed \
			#| sort -u \
	#)" \
 #&& apk add --no-cache --virtual .rundeps $runDeps \
 #&& rm -rf /tmp/* && apk del --no-cache .build-deps

#run apk add php7-gd

COPY configs/php /etc/php
COPY configs/php/php-fpm.conf /usr/local/etc/

#RUN apk update --no-cache && apk add --no-cache wget
#RUN ln -s /usr/local/bin/php /bin/php

EXPOSE 9000
CMD ["php-fpm"]
