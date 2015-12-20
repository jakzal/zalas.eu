FROM php:7.0

RUN buildDeps="zlib1g-dev" \
  && apt-get update && apt-get install --no-install-recommends -y git $buildDeps && rm -r /var/lib/apt/lists/* \
  && docker-php-ext-install mbstring zip \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps

RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 8000

CMD ["./vendor/bin/sculpin", "generate", "--server", "--watch"]

