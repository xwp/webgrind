FROM php:7.4-apache as builder

COPY . /build

RUN apt-get update \
    && apt-get install -y build-essential \
    && cd /build \
    && make \
    && sed -i 's/\(^ *\)\/\/\(.*DOCKER:ENABLE\)/\1\2/g' config.php \
    && sed -i 's/\(^ *\)\/\/\(.*DOCKER:ENABLE\)/\1\2/g' index.php

FROM php:7.4-apache
WORKDIR /var/www/html

RUN apt-get update \
    && apt-get install -y graphviz python3 \
    && rm -rf /var/lib/apt/lists/*

COPY . /var/www/html
COPY --from=builder /build/bin/preprocessor /var/www/html/bin/preprocessor
