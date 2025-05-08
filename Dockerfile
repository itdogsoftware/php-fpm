FROM php:8.3.14-fpm-bullseye
LABEL authors = "Roy To <roy.to@itdogsoftware.co>"
# Install NVM
RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
# Set up environment variables for NVM
ENV NVM_DIR=/root/.nvm
ENV PATH="$NVM_DIR/versions/node/v16.20.0/bin:$PATH"
# Install Node.js 16 and set it as default
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install 16.20.0 && nvm alias default 16.20.0"
# Install library & necessary service
RUN apt-get update && apt-get install -y libzip-dev zip libpng-dev cron supervisor vim nodejs gettext-base && rm -rf /var/lib/apt/lists/*
# Install docker php extensions
RUN pecl install redis && docker-php-ext-enable redis
RUN docker-php-ext-install mysqli 
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install opcache
RUN docker-php-ext-install zip
RUN docker-php-ext-configure gd --with-freetype
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