FROM php:7.0

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -r /var/lib/apt/lists/* \
 && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false

RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 8000

CMD ["./vendor/bin/sculpin", "generate", "--server", "--watch"]

