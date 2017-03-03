FROM php:7.1-cli

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apt-get update && apt-get install -y --no-install-recommends git unzip zlib1g-dev \
  && docker-php-ext-install mbstring zip \
  && rm -r /var/lib/apt/lists/* && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps
RUN curl -Ls https://getcomposer.org/composer.phar > /usr/local/bin/composer && chmod +x /usr/local/bin/composer

EXPOSE 8000

CMD ["./vendor/bin/sculpin", "generate", "--server", "--watch"]
