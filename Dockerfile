FROM php:8.4.5-apache-bullseye

LABEL maintainer="Juri Hahn <juri@hahn21.de>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    cron \
    ca-certificates \
    openssl \
    zip \
    unzip \
    libbz2-dev \
    zlib1g-dev \
    libzip-dev \
    libgd-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libonig-dev \
    libwebp-dev && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install -j$(nproc) gd exif mysqli bz2 zip opcache && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite ssl expires && \
    touch /etc/apache2/conf-available/expires.conf && a2enconf expires.conf && \
    a2ensite default-ssl