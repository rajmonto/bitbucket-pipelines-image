# This file is used in bitbucket pipelines
FROM composer:2.8.8 AS composer
FROM php:8.3.36-fpm-bookworm

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

RUN apt-get update \
    && apt-get install -qy curl gnupg libxml2-dev unzip gettext zip git libzip-dev default-mysql-client locales python3-pip libjpeg-dev libwebp-dev libpng-dev \
    && docker-php-ext-configure gd --with-jpeg --with-webp \
    && docker-php-ext-install soap pdo_mysql bcmath zip intl gettext gd \
    && echo 'max_execution_time = 90' >> $PHP_INI_DIR/conf.d/php.ini \
    && echo 'memory_limit = 512M' >> $PHP_INI_DIR/conf.d/php.ini \
    && echo 'date.timezone = "Europe/Stockholm"' >> $PHP_INI_DIR/conf.d/php.ini \
    && curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -qy nodejs  \
    && npm install -g aws-cdk \
    && apt-get -qy install awscli \
    && locale-gen sv_SE.UTF-8 && locale-gen en_US.UTF-8
