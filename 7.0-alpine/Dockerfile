FROM alpine:3.9
MAINTAINER Santiago <hrcarsan@gmail.com>

RUN apk update --no-cache \
 ## install dependencies =========================
 && apk add --no-cache --virtual .build-deps \
    openssl \
    openssl-dev \
    curl \
    g++ \
    libxml2-dev \
    bzip2-dev \
    curl-dev \
    libpng-dev \
    freetype-dev \
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
 ## install php ==================================
 && addgroup -g 82 -S www-data && adduser -u 82 -D -S -G www-data www-data \
 && cd /tmp \
 && export PHP_VERSION=7.0.32 \
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
  --with-gd \
  --with-freetype-dir=/usr/include/freetype2/ \
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
 && make && make install && make clean \
 && mkdir -p /etc/php/conf.d/ \
 ## install timezonedb extension =================
 && pecl install timezonedb \
 ## install ioncube extension ===================
 && cd /tmp \
 && wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
 && tar xvfz ioncube_loaders_lin_x86-64.tar.gz \
 && cd ioncube \
 && mkdir -p /usr/local/lib/php/extensions/no-debug-non-zts-20151012/ \
 && cp ioncube_loader_lin_7.0.so /usr/local/lib/php/extensions/no-debug-non-zts-20151012/ \
 # install redis extension =====================
 && pecl install redis \
 ## clean ========================================
 && runDeps="$( \
		scanelf --needed --nobanner --recursive /usr/local \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	)" \
 && apk add --no-cache --virtual .rundeps $runDeps \
 && rm -rf /tmp/* && apk del --no-cache .build-deps

COPY configs/php /etc/php
COPY configs/php/php-fpm.conf /usr/local/etc/

EXPOSE 9000
CMD ["php-fpm"]
