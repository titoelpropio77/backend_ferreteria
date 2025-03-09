FROM php:8.3-apache


ARG WWWUSER=1000
ARG WWWGROUP=1000
WORKDIR /var/www/html/
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="10000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="192" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10"
RUN apt update \
        && apt upgrade -y\
        && apt install -y \
            g++ \
            libicu-dev \
            libpq-dev \
            libzip-dev \
            zip \
            zlib1g-dev \
            htop \
            vim\
            postgresql\
            postgresql-contrib
RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql sockets pgsql opcache
ARG INSTALL_PHPREDIS=true
RUN if [ ${INSTALL_PHPREDIS} = true ]; then \
    # Install Php Redis Extension
    printf "\n" | pecl install -o -f redis \
    printf "\n" | curl 'http://pecl.php.net/get/redis-6.0.2.tgz' -o redis-6.0.2.tgz \
    && pecl install redis-6.0.2.tgz \
    &&  rm -rf redis-6.0.2.tgz \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis \
;fi

###########################################
# pcntl
###########################################
ARG INSTALL_PCNTL=true
RUN if [ ${INSTALL_PCNTL} = true ]; then \
  docker-php-ext-install pcntl \
  ;fi
###########################################
# bcmath:
###########################################
ARG INSTALL_BCMATH=true
RUN if [ ${INSTALL_BCMATH} = true ]; then \
  docker-php-ext-install bcmath \
  ;fi


###########################################################################
# Human Language and Character Encoding Support:
###########################################################################
ARG INSTALL_INTL=true
RUN if [ ${INSTALL_INTL} = true ]; then \
    # Install intl and requirements
    apt-get install -yqq zlib1g-dev libicu-dev g++ && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl \
;fi
RUN docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install opcache
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini && \
        sed -i -e "s/^ *memory_limit.*/memory_limit = 4G/g" /usr/local/etc/php/php.ini
        #&& pecl install xdebug-2.8.1
       # && docker-php-ext-enable redis xdebug
RUN echo "ServerName laravel-app.local" >> /etc/apache2/apache2.conf
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN a2enmod rewrite
RUN a2enmod rewrite headers
###########################################################################
# Configs Octane Permision:
###########################################################################
RUN groupadd --force -g $WWWGROUP octane
RUN useradd -ms /bin/bash --no-user-group -g $WWWGROUP -u 1337 octane

#COPY  ./Docker/config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#There is no supervisord.conf file in project
#COPY  ./docker_conf_files/supervisor/supervisor.conf /etc/supervisor/conf.d/supervisord.conf
 ##COPY ./docker_conf_files/supervisor/laravel-worker.conf /etc/supervisor/conf.d/laravel-worker.conf
 ##COPY ./docker_conf_files/supervisor/supervisor.conf /etc/supervisor/conf.d/worker.conf
#RUN disabled-xdebug
RUN chmod 777 -R -c /var/www
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
WORKDIR /var/www/html
##COPY ["composer.json", "composer.lock", "./"]
COPY ["./" , "./"]
RUN chown -R www-data:www-data .
EXPOSE 8800
