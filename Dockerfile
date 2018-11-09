FROM gcr.io/google-appengine/php72:latest

RUN apt-get update -y
RUN apt-get install autoconf -y
RUN apt-get install build-essential -y
RUN yes '' | pecl install swoole

ONBUILD RUN docker-php-ext-install bcmath
ONBUILD RUN docker-php-ext-install redis
ONBUILD RUN docker-php-ext-install opencensus
ONBUILD RUN docker-php-ext-install gd
ONBUILD RUN docker-php-ext-enable swoole
ONBUILD RUN echo "extension=swoole.so" >> /opt/php72/lib/conf.d/php.ini
ONBUILD RUN php72-enmod swoole

# Allow customizing some composer flags
ONBUILD ARG COMPOSER_FLAGS='--no-scripts --no-dev --prefer-dist'
ONBUILD ENV COMPOSER_FLAGS=${COMPOSER_FLAGS}

# Copy the app and change the owner
ONBUILD COPY . $APP_DIR
ONBUILD RUN chown -R www-data.www-data $APP_DIR

ONBUILD RUN /build-scripts/composer.sh

ENTRYPOINT ["/build-scripts/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
