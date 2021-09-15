FROM php:7.4.23-fpm-buster

LABEL authors = "Roy To <roy.to@itdogsoftware.co>"

# Install zip-dev
RUN apt-get update && apt-get install -y libzip-dev zip

# Install docker php extensions
RUN docker-php-ext-install mysqli 
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install opcache
RUN docker-php-ext-install zip

# set production config
RUN mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

# Update php config
RUN sed -i "/memory_limit\s=\s/s/=.*/= 512M/" /usr/local/etc/php/php.ini

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 9000