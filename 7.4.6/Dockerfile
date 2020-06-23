# STEPS TO BUILD
# docker run --rm -it --network host hrcarsan/php-fpm:7.4.6-build bash
# python3 -m http.server 8100 --bind 127.0.0.1
# docker build --network host -t hrcarsan/php-fpm:7.4.6 .
# docker run --rm -it hrcarsan/php-fpm:7.4.6 bash
FROM hrcarsan/ubuntu:20.04-mq
LABEL maintainer="hrcarsan@gmail.com"

RUN  apt-get update -y \
  && apt install -y --no-install-recommends wget \
  && wget http://localhost:8100/php.tar.gz \
  && wget http://localhost:8100/php-fpm.tar.gz \
  && apt-get --purge --autoremove -y remove wget \
  && rm -rf /var/lib/apt/lists/* \
  && tar xvkf php.tar.gz; rm php.tar.gz \
  && tar xvkf php-fpm.tar.gz; rm php-fpm.tar.gz \
  && mkdir -p /usr/local/var/log \
  && ln -s /usr/local/bin/php /bin/php

##RUN groupadd www-data && useradd -g www-data www-data
##RUN groupmod -g 3009 www-data \
   ##&& usermod -u 3009  www-data
   ##&& groupadd -g 1000 mqm  && useradd -u 999 -g mqm -d /var/mqm mqm  \
   ##&& mkdir -p /var/www && chown -R www-data: /var/www

COPY configs/php /etc/php/fpm

EXPOSE 9000
CMD php-fpm -c /etc/php/fpm/php.ini -y /etc/php/fpm/php-fpm.conf
