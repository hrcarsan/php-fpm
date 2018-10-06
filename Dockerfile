FROM ubuntu:16.04
MAINTAINER Santiago Herrera Cardona <santiagohecar@gmail.com>

# install dependencies
RUN apt-get update \
 && apt-get -y install build-essential curl autoconf libxml2-dev libssl-dev \
                       libbz2-dev libpng-dev libc-client-dev libkrb5-dev libmcrypt-dev \
                       pkg-config libreadline-dev libmysqlclient-dev libtool autoconf nginx libgd-dev \
                       wget net-tools

# install openssl
RUN cd /tmp \
 && wget https://www.openssl.org/source/old/0.9.x/openssl-0.9.8zh.tar.gz \
 && tar -zxvf openssl-0.9.8zh.tar.gz \
 && cd openssl-0.9.8zh \
 && ./config --prefix=/usr/local --openssldir=/usr/local/openssl-0.9.8 \
 && make \
 && make install

# install libcurl
RUN cd /usr/local/include \
 && ln -s /usr/include/x86_64-linux-gnu/curl curl \
 && apt-get install -y libcurl4-gnutls-dev

# install php
RUN cd /usr/local/src/ \
 && export PHP_VERSION=5.3.29 \
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
 && make \
 && make install \
 && mkdir -p /etc/php/conf.d

# instasll timezonedb extension
RUN pecl install timezonedb \
 && echo "extension=timezonedb.so" >> /etc/php/php.ini

# install ioncube extension
RUN cd /tmp \
 && wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
 && tar xvfz ioncube_loaders_lin_x86-64.tar.gz \
 && cd ioncube \
 && cp ioncube_loader_lin_5.3.so /usr/local/lib/php/extensions/no-debug-non-zts-20090626/

# install xcache
RUN cd /tmp \
 && export XCACHE_VER=3.1.0 \
 && wget http://xcache.lighttpd.net/pub/Releases/$XCACHE_VER/xcache-$XCACHE_VER.tar.gz \
 && tar xzvf xcache-$XCACHE_VER.tar.gz \
 && cd xcache-$XCACHE_VER \
 && phpize \
 && ./configure --enable-xcache \
 && make \
 && make install \
 && echo "extension=xcache.so" >> /etc/php/php.ini

COPY configs/php /etc/php

RUN ln -s /etc/php/php-fpm.conf /usr/local/etc/php-fpm.conf

EXPOSE 9000
CMD ["php-fpm"]
