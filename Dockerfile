FROM php:8.4.11-fpm-bullseye
LABEL authors = "Roy To <roy.to@itdogsoftware.co>"
# Install NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
RUN bash -c "source ~/.bashrc && nvm install 18"
# Install library & necessary service
RUN apt-get update && apt-get install -y libzip-dev zip libfreetype6-dev libjpeg62-turbo-dev libpng-dev cron supervisor vim nodejs gettext-base && rm -rf /var/lib/apt/lists/*
# Install docker php extensions
RUN pecl install redis && docker-php-ext-enable redis
RUN docker-php-ext-install mysqli 
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install opcache
RUN docker-php-ext-install zip
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd
RUN docker-php-ext-install sockets
RUN docker-php-ext-install pcntl
# set production config
RUN mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
# enable opcache config
COPY docker-php-ext-opcache.ini /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
# Update php config
RUN sed -i "/memory_limit\s=\s/s/=.*/= 512M/" /usr/local/etc/php/php.ini
# tune up php-fpm config
COPY www.conf /usr/local/etc/php-fpm.d/www.conf
# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
EXPOSE 9000