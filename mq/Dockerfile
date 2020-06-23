# docker build -t hrcarsan/ubuntu:20.04-mq .
FROM ubuntu:20.04
LABEL maintainer="hrcarsan@gmail.com"

# reference: http://webspherepundit.com/?p=1373
# check if is installed 'rpm -qa | grep -i mq'
# check version info '/opt/mqm/bin/dspmqver' or 'dspmqver -a'

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update -y \
 && apt-get install -y --no-install-recommends \
# ==== BUILD DEPENDENCIES ==== #
    git \
    ca-certificates \
    rpm \
 # ==== INSTALL MQ CLIENT ==== #
 && cd /tmp \
 && git clone https://github.com/hrcarsan/mqc.git \
 && cd mqc/mqc75_7.5.0.2_linuxx86-64/ \
 && ./join \
 && tar -xvf mqc75_7.5.0.2_linuxx86-64.tar.gz \
 && groupadd mqm \
 && useradd -g mqm mqm \
 && ./mqlicense.sh -accept \
 && rpm -ivh --nodeps --force-debian MQSeriesRuntime-7.5.0-2.x86_64.rpm \
 && rpm -ivh --nodeps --force-debian MQSeriesSDK-7.5.0-2.x86_64.rpm \
 && rpm -ivh --nodeps --force-debian MQSeriesClient-7.5.0-2.x86_64.rpm \
 && runuser -l mqm -c '. /opt/mqm/bin/setmqenv'; \
 # ==== CLEAN ==== #
 apt-get --purge -y remove \
    git \
    ca-certificates \
    rpm \
 && apt autoremove -y \
 && rm -rf /tmp/* \
 && rm -rf /var/lib/apt/lists/*
