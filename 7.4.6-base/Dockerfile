FROM ubuntu:20.04 as builder
LABEL maintainer="hrcarsan@gmail.com"

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update -y \
  # ================== BUILD DEPENDENCIES ==================
  && apt-get install -y --no-install-recommends \
    curl ca-certificates pkg-config g++ libxml++2.6-dev libsqlite3-dev make \
  # ================== INSTALl PHP ================== #
  && cd /tmp \
  && export PHP_VERSION=7.4.6 \
  && curl -SL "http://php.net/get/php-$PHP_VERSION.tar.gz/from/this/mirror" \
          -o php-$PHP_VERSION.tar.gz \
  && tar -xzvf php-$PHP_VERSION.tar.gz \
  && cd php-$PHP_VERSION \
  && ./configure \
  && make \
  && make install

COPY ./tar_binary /

RUN chmod +x tar_binary \
  && ./tar_binary /usr/local/bin/php

#######################################################
FROM ubuntu:20.04
LABEL maintainer="hrcarsan@gmail.com"

RUN export DEBIAN_FRONTEND=noninteractive

COPY --from=builder /php.tar.gz /
RUN tar xvfz php.tar.gz && rm php.tar.gz
