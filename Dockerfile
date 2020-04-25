FROM php:7-apache

RUN set -x \
    DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        git \
        libcurl3-dev \
        libonig-dev \
        libssh2-1-dev \
        libzip-dev \
    && ( \
        cd /tmp \
        && git clone https://git.php.net/repository/pecl/networking/ssh2.git \
        && cd /tmp/ssh2/ \
        && .travis/build.sh \
    ) \
    && docker-php-ext-install -j$(nproc) curl \
    && docker-php-ext-install -j$(nproc) mbstring \
    && docker-php-ext-install -j$(nproc) pdo \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-enable curl \
    && docker-php-ext-enable mbstring \
    && docker-php-ext-enable pdo \
    && docker-php-ext-enable pdo_mysql \
    && docker-php-ext-enable ssh2 \
    && docker-php-ext-enable zip \
    && apt-get remove --purge --auto-remove -y git \
    && rm -rf /var/lib/apt/lists/* /tmp/ssh2

WORKDIR /var/www/html

COPY --chown=www-data:www-data . ./ranksystem

EXPOSE 80/tcp
