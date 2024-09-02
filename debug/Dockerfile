FROM php:8.3.11-apache-bookworm

MAINTAINER Juri Hahn <juri@hahn21.de>

RUN apt-get update

RUN apt-get install -y apt-utils cron ca-certificates openssl

RUN apt-get install -y zip unzip libbz2-dev zlib1g-dev libzip-dev

RUN apt-get install -y libgd-dev libjpeg-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libonig-dev libwebp-dev

RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp

RUN docker-php-ext-install -j$(nproc) gd exif mysqli bz2 zip opcache


RUN pecl install xdebug-3.3.2
RUN docker-php-ext-enable xdebug
RUN echo "xdebug.mode=develop,debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini


RUN a2enmod rewrite

RUN touch /etc/apache2/conf-available/expires.conf && a2enconf expires.conf
RUN a2enmod expires

RUN a2enmod ssl

RUN a2ensite default-ssl
