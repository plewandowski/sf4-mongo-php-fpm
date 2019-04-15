FROM php:7.2-fpm

# prerequisites 
RUN apt-get update
RUN apt-get install -y autoconf pkg-config libssl-dev zlib1g-dev libzip-dev unzip libpng-dev libjpeg-dev libgif-dev libtiff-dev 
RUN apt-get install -y g++ libicu-dev icu-devtools

# additional php ext
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install zip
RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ && docker-php-ext-install gd
RUN docker-php-ext-install intl

# image magic support
RUN apt-get install -y libmagickwand-dev imagemagick
RUN pecl install imagick
RUN docker-php-ext-enable imagick 

# add mongodb support
RUN pecl install mongodb
RUN echo "extension=mongodb.so" >> /usr/local/etc/php/conf.d/mongodb.ini

# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

