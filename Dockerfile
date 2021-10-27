FROM ubuntu:latest


ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y git gcc build-essential bison re2c pkg-config autoconf libxml2-dev sqlite3  libsqlite3-dev gdb python3.8 python3-pip openssl libssl-dev\
    && cd / \
    && git clone https://github.com/php/php-src.git \
    && cd /php-src \
    && git checkout PHP-7.1.0 \
    && rm -rf /php-src/pear/fetch.php

COPY ./patch/fetch.php /php-src/pear/fetch.php

RUN cd /php-src \
    && ./buildconf --force \
    && ./configure  --with-openssl\
    && make  && make install

RUN  pip install gdbgui

EXPOSE 9411
WORKDIR /php-src
CMD  gdbgui php --host 0.0.0.0 -p 9411


