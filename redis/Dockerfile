ARG ASTRA_LINUX
FROM $ASTRA_LINUX

ENV TZ=Europe/Moscow

ADD packages/sources.list /etc/apt/
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y lsb-release && apt-get clean all \
    && apt-get install -y redis-server

ADD redis/distr/redis.conf /etc/redis/redis.conf

ARG SS_LOG_LEVEL

RUN sed -i 's/${SS_LOG_LEVEL}/'$SS_LOG_LEVEL'/g' /etc/redis/redis.conf && \
    ln -sf /proc/self/fd/1 /var/log/redis/redis-server.log

EXPOSE 6379

USER redis

CMD /usr/bin/redis-server /etc/redis/redis.conf --daemonize yes && \
    redis-cli monitor
