FROM php:7.4-fpm
# Copy composer.lock and composer.json
COPY . /var/www
# Set working directory
WORKDIR /var/www/
# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    default-mysql-client \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libmcrypt-dev \
    libonig-dev \
    libzip-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-freetype  --with-jpeg
RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
WORKDIR /var/www/api
RUN COMPOSER_MEMORY_LIMIT=-1 composer self-update 1.10.10
RUN COMPOSER_MEMORY_LIMIT=-1 composer install --no-interaction --no-scripts --ignore-platform-reqs
RUN COMPOSER_MEMORY_LIMIT=-1 composer dump-autoload --no-interaction   
COPY .env.example .env
RUN chown -R www-data:www-data /var/www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
#docker tag local-image:tagname new-repo:tagname
#docker push new-repo:tagname