FROM debian:8-slim
MAINTAINER Santiago Herrera Cardona <santiagohecar@gmail.com>

RUN set -ex; \
 apt-get update; \
 # install build dependencies
 apt-get install -y \
    curl \
    g++ \
    wget \
    make \
    autoconf \
    ca-certificates \
    --no-install-recommends; \
 savedAptMark="$(apt-mark showmanual)"; \
 # install runtime dependencies
 apt-get install -y \
    libxml2-dev \
    zlib1g-dev \
    libbz2-dev \
    libpng-dev \
    libfreetype6-dev \
    libc-client-dev \
    libkrb5-dev \
    libmcrypt-dev \
    libmysqlclient-dev \
    libreadline-dev \
    --no-install-recommends; \
 # install openssl
 cd /tmp; \
 wget https://www.openssl.org/source/old/0.9.x/openssl-0.9.8zh.tar.gz; \
 tar -zxvf openssl-0.9.8zh.tar.gz; \
 cd openssl-0.9.8zh; \
 ./config; \
 make && make install; \
 # install libcurl
 ln -s /usr/include/x86_64-linux-gnu/curl /usr/local/include/curl; \
 apt-get install -y libcurl4-gnutls-dev --no-install-recommends; \
 # fix for freetype
 mkdir /usr/include/freetype2/freetype; \
 ln -s /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h; \
 # install php
 cd /tmp \
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
 && make && make install && make clean \
 && mkdir -p /etc/php/conf.d/; \
 # install timezonedb extension
 pecl install timezonedb; \
 # install ioncube extension
 cd /tmp \
 && wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
 && tar xvfz ioncube_loaders_lin_x86-64.tar.gz \
 && cd ioncube \
 && mkdir -p /usr/local/lib/php/extensions/no-debug-non-zts-20090626/ \
 && cp ioncube_loader_lin_5.3.so /usr/local/lib/php/extensions/no-debug-non-zts-20090626/; \
 #install xcache
 cd /tmp \
 && export XCACHE_VER=3.1.0 \
 && wget http://xcache.lighttpd.net/pub/Releases/$XCACHE_VER/xcache-$XCACHE_VER.tar.gz \
 && tar xzvf xcache-$XCACHE_VER.tar.gz \
 && cd xcache-$XCACHE_VER \
 && phpize \
 && ./configure --enable-xcache \
 && make \
 && make install; \
 # clean
 apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
	find /usr/local -type f -executable -exec ldd '{}' ';' \
		| awk '/=>/ { print $(NF-1) }' \
		| sort -u \
		| xargs -r dpkg-query --search \
		| cut -d: -f1 \
		| sort -u \
		| xargs -r apt-mark manual \
	; \
 apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
 rm -rf /tmp/*; \
 rm -r /var/lib/apt/lists/*;

COPY configs/php /etc/php
COPY configs/php/php-fpm.conf /usr/local/etc/

EXPOSE 9000
CMD ["php-fpm"]
