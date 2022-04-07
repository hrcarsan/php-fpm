# STEPS TO BUILD
# docker run --rm -it --network host hrcarsan/php-fpm:7.4.6-build bash
# python3 -m http.server 8100 --bind 127.0.0.1
# docker build --network host -t hrcarsan/php-fpm:7.4.6 .
# docker run --rm -it hrcarsan/php-fpm:7.4.6 bash
FROM ubuntu:20.04
LABEL maintainer="hrcarsan@gmail.com"

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update -y \
  && apt install -y --no-install-recommends wget \
  # Download programs
  && wget http://localhost:8100/php.tar.gz \
  && wget http://localhost:8100/php-fpm.tar.gz \
  && wget http://localhost:8100/wget.tar.gz \
  && wget http://localhost:8100/phpunit \
  && wget http://localhost:8100/composer.phar \
  && apt-get --purge --autoremove -y remove wget \
  && rm -rf /var/lib/apt/lists/* \
  # Install programs
  && tar xvf php.tar.gz --skip-old-files \
  && tar xvf php-fpm.tar.gz --skip-old-files \
  && tar xvf wget.tar.gz --skip-old-files \
  && chmod +x composer.phar && mv composer.phar /bin/composer \
  && chmod +x phpunit && mv phpunit /bin/phpunit \
  && rm -rf *.tar.gz \
  # Extra configs
  && mkdir -p /usr/local/var/log \
  && ln -s /usr/local/bin/php /bin/php

COPY configs/php /etc/php/fpm

EXPOSE 9000
CMD php-fpm -c /etc/php/fpm/php.ini -y /etc/php/fpm/php-fpm.conf
