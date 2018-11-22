FROM gcr.io/google-appengine/php72:latest

ARG ENABLE_XDEBUG

RUN apt-get update -y
RUN apt-get install autoconf -y
RUN apt-get install build-essential -y
RUN yes '' | pecl install swoole

# Option to install xdebug
RUN echo "Will enable XDEBUG: $ENABLE_XDEBUG"
RUN if [ "$ENABLE_XDEBUG" = "true" ]; then pecl install xdebug; fi
RUN if [ "$ENABLE_XDEBUG" = "true" ]; then echo "zend_extension=/opt/php72/lib/x86_64-linux-gnu/extensions/no-debug-non-zts-20170718/xdebug.so" >> /opt/php72/lib/php.ini; fi
ONBUILD RUN if [ "$ENABLE_XDEBUG" = "true" ]; then php72-enmod xdebug; fi
ONBUILD RUN if [ "$ENABLE_XDEBUG" = "true" ]; then docker-php-ext-enable xdebug; fi

ONBUILD RUN docker-php-ext-install bcmath
ONBUILD RUN docker-php-ext-install redis
ONBUILD RUN docker-php-ext-install opencensus
ONBUILD RUN docker-php-ext-install gd
ONBUILD RUN docker-php-ext-enable swoole

# Allow customizing some composer flags
ONBUILD ARG COMPOSER_FLAGS='--no-scripts --no-dev --prefer-dist'
ONBUILD ENV COMPOSER_FLAGS=${COMPOSER_FLAGS}

# Copy the app and change the owner
ONBUILD COPY . $APP_DIR
ONBUILD RUN chown -R www-data.www-data $APP_DIR

ONBUILD RUN /build-scripts/composer.sh

ENTRYPOINT ["/build-scripts/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
