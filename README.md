# zalas.eu

[![Build Status](https://travis-ci.org/jakzal/zalas.eu.svg?branch=source)](https://travis-ci.org/jakzal/zalas.eu)

To build the site locally you can use docker-compose from the [Docker toolbox](https://www.docker.com/docker-toolbox).

## Install dependencies

    docker-compose run --rm --service-ports sculpin composer install --prefer-dist

## Run the sculpin generator

    docker-compose up

If you prefer to tweak the command:

    docker-compose run --rm --service-ports sculpin ./vendor/bin/sculpin generate --server --watch
