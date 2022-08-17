# docker build . -t hrcarsan/php-fpm:7.4.6-amd-arm
# docker run --rm -it hrcarsan/php-fpm:7.4.6-amd-arm bash
#
# docker buildx build . --platform linux/amd64 --push -t hrcarsan/php-fpm:7.4.6-amd
# docker buildx build . --platform linux/arm64 --push -t hrcarsan/php-fpm:7.4.6-arm
# docker buildx build . --platform linux/amd64,linux/arm64 --push -t hrcarsan/php-fpm:7.4.6-amd-arm
# docker run -it --platform linux/amd64 hrcarsan/php-fpm:7.4.6-amd-arm bash
# docker run -it --platform linux/arm64 hrcarsan/php-fpm:7.4.6-amd-arm bash

FROM ubuntu:20.04 as build
LABEL maintainer="hrcarsan@gmail.com"

# ================== INSTALL DEPENDENCIES ==================
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update -y \
  && apt install -y --no-install-recommends \
      curl wget zip git ca-certificates \
      pkg-config g++ libxml++2.6-dev libsqlite3-dev make autoconf \
      libbz2-dev libcurl4-gnutls-dev libpng-dev \
      libjpeg-dev libfreetype6-dev libc-client-dev libkrb5-dev \
      openssl libonig-dev libzip-dev libmcrypt-dev libssh2-1-dev \
      libzmq3-dev libwebp-dev libxpm-dev

# ================== INSTALl PHP ================== #
RUN  export PHP_VERSION=7.4.6 \
  && cd /tmp \
  && curl -SL "http://php.net/get/php-$PHP_VERSION.tar.gz/from/this/mirror" \
          -o php-$PHP_VERSION.tar.gz \
  && tar -xzvf php-$PHP_VERSION.tar.gz \
  && cd php-$PHP_VERSION \
  && ./configure \
    --disable-cgi \
    --with-pear \
    --with-bz2 \
    --with-curl \
    --enable-gd \
    --with-freetype \
    --with-jpeg \
    --with-webp \
    --with-pic \
    --with-imap \
    --with-imap-ssl \
    --with-kerberos \
    --enable-mbstring \
    --enable-sockets \
    --enable-mysqlnd \
    --enable-opcache \
    --with-mysqli \
    --with-pdo-mysql \
    --with-xmlrpc \
    --with-zip \
    --enable-soap \
    --enable-pcntl \
    --with-zlib \
    --with-xpm \
    --with-openssl \
    --with-sodium \
    --enable-fpm \
    --with-fpm-user=www-data \
    --with-fpm-group=www-data  \
    --with-config-file-path=/etc/php/fpm \
    --with-config-file-scan-dir=/etc/php/fpm/conf.d \
  && make \
  && make install \
  && mkdir -p /etc/php/fpm \
  && mkdir -p /usr/local/var/log \
  && ln -s /usr/local/bin/php /bin/php

RUN  pecl install timezonedb
RUN  pecl install igbinary
RUN  pecl install redis
RUN  pecl install mcrypt
RUN  pecl install https://pecl.php.net/get/ssh2-1.2.tgz

COPY configs/php /etc/php/fpm

# =============== TAR BINARIES ============== #
#RUN apt update \
  #&& wget https://raw.githubusercontent.com/hrcarsan/dotfiles/master/filefilter.py \
  #&& wget https://raw.githubusercontent.com/hrcarsan/dotfiles/master/tar_binary \
  #&& chmod +x tar_binary \
  #&& ./tar_binary $(which php) "php -m" \
  #&& ./tar_binary $(which php-fpm) "php-fpm -m" \
  #&& ./tar_binary $(which wget) "wget --delete-after google.com"

RUN  cd / \
  && apt update \
  && apt install unzip \
  && ldconfig -p | sed "s/^.*=> //" >> libs.file.lst \
  && cat libs.file.lst | zip -@ libs.zip \
  && mkdir libs_tmp \
  && cd libs_tmp \
  && unzip ../libs.zip \
  && tar cvfz ../libs.tar.gz *

# =============== MINIMIZE ============== #
FROM ubuntu:20.04

COPY --from=build /usr/local/lib/php/extensions/no-debug-non-zts-20190902 /usr/local/lib/php/extensions/no-debug-non-zts-20190902
COPY --from=build /libs.tar.gz /libs.tar.gz
COPY --from=build /usr/local/bin/php /usr/local/bin/php
COPY --from=build /usr/local/sbin/php-fpm /usr/local/sbin/php-fpm
COPY --from=build /usr/bin/wget /usr/bin/wget
#COPY --from=build /php.tar.gz /php.tar.gz
#COPY --from=build /php-fpm.tar.gz /php-fpm.tar.gz
#COPY --from=build /wget.tar.gz /wget.tar.gz
#COPY --from=build /usr/local/lib/php/extensions/no-debug-non-zts-20190902 /usr/local/lib/php/extensions/no-debug-non-zts-20190902

# Install programs
RUN cd / \
  && tar xvf libs.tar.gz --skip-old-files \
  #&& tar xvf php.tar.gz --skip-old-files \
  #&& tar xvf php-fpm.tar.gz --skip-old-files \
  #&& tar xvf wget.tar.gz --skip-old-files \
  && rm -rf *.tar.gz \
  # Extra configs
  && mkdir -p /usr/local/var/log \
  && ln -s /usr/local/bin/php /bin/php

COPY configs/php /etc/php/fpm

EXPOSE 9000
CMD php-fpm -c /etc/php/fpm/php.ini -y /etc/php/fpm/php-fpm.conf
