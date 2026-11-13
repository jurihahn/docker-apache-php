FROM php:8.4.27-apache

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
    apt-get install -y --only-upgrade apache2 apache2-bin apache2-data apache2-utils && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install -j$(nproc) gd exif mysqli bz2 zip opcache && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite ssl expires && \
    touch /etc/apache2/conf-available/expires.conf && a2enconf expires.conf && \
    a2ensite default-ssl

# WID-SEC-2026-4517: the build fails unless Apache is 2.4.71 or newer and http2, md and vhost_alias stay off.
ARG APACHE_MIN=2.4.71
RUN v=$(dpkg-query -W -f='${Version}' apache2-bin) && \
    dpkg --compare-versions "$v" ge "$APACHE_MIN" || { echo "apache2-bin $v is older than $APACHE_MIN"; exit 1; }; \
    n=$(ls /etc/apache2/mods-enabled | grep -c -E '^(http2|md|vhost_alias)[.]load$'); \
    [ "$n" = 0 ] || { echo "http2, md or vhost_alias enabled ($n)"; exit 1; }; \
    echo "apache2-bin $v, http2/md/vhost_alias enabled 0"
