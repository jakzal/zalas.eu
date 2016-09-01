FROM php:7.0-alpine

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apk --no-cache add git unzip \
  && docker-php-ext-install mbstring zip
RUN curl -Ls https://getcomposer.org/composer.phar > /usr/local/bin/composer && chmod +x /usr/local/bin/composer

EXPOSE 8000

CMD ["./vendor/bin/sculpin", "generate", "--server", "--watch"]
