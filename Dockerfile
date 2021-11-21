
# Base layout, install PHP extensions and PECL modules.
FROM php:7.4-fpm

LABEL name="aliart/php:7.4-fpm"

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN buildDeps=" \
        default-libmysqlclient-dev \
        libbz2-dev \
        libmemcached-dev \
        libsasl2-dev \
    " \
    runtimeDeps=" \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libldap2-dev \
        libmemcachedutil2 \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
        libcurl4-openssl-dev \
        pkg-config \
        libssl-dev \
        libonig-dev \
    " \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        $buildDeps \
        $runtimeDeps \
        lsb-release \
        apt-transport-https \
        ca-certificates \
        locales \
        locales-all \
        autoconf \
        autogen \
        openssh-client \
        build-essential \
        apt-utils \
        software-properties-common \
        vim \
        wget \
        curl \
        unzip \
        zip \
        && docker-php-ext-install bcmath bz2 calendar iconv intl mbstring mysqli opcache pdo_mysql gd \
        && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
        && docker-php-ext-install ldap \
        && docker-php-ext-install exif \
        && pecl install mongodb \
        && docker-php-ext-enable mongodb \
        && apt-get purge -y --auto-remove $buildDeps \
        && rm -r /var/lib/apt/lists/*

ENV PHP_EXTRA_CONFIGURE_ARGS --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data
#/>
