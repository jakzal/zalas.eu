FROM php:7.2-cli

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apt-get update && apt-get install -y --no-install-recommends git unzip zlib1g-dev \
  && docker-php-ext-install mbstring zip \
  && rm -r /var/lib/apt/lists/* && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps
COPY --from=composer:1.5 /usr/bin/composer /usr/bin/composer

EXPOSE 8000

CMD ["./vendor/bin/sculpin", "generate", "--server", "--watch"]
