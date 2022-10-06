FROM php:8.1.11-apache-buster
# Arguments
ARG user
ARG uid
# Install dependencies
RUN apt-get update && apt-get install -y \
 nano \
 git \
 curl \
 libpng-dev \
 libonig-dev \
 libxml2-dev \
 libzip-dev \
 zip \
 unzip
# Using Debian, as root
RUN curl -fsSL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring bcmath gd zip
# RUN echo 'memory_limit = 512M' >> /usr/local/etc/php/conf.d/docker-phpmemlimit.ini;
# Enable module rewrite apache2
RUN a2enmod rewrite
# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
chown -R $user:$user /home/$user
# Set working directory
WORKDIR /var/www
USER $user