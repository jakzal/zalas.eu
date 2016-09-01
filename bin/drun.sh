#!/bin/bash

set -e
set -u
set -o pipefail

COMMAND=${1:-"help"}

function build() {
    docker build -t zalas.eu/php ./docker/php/
}

function sculpin() {
    docker run -it --rm \
        -v $(pwd):/zalas.eu \
        -v $HOME/.composer/cache:/root/.composer/cache \
        -w /zalas.eu \
        -p 8000:8000 \
        zalas.eu/php \
         ${@:-./vendor/bin/sculpin generate --server --watch}
}

function php() {
    run zalas.eu/php php ${@:-"-v"}
}

function sh() {
    run zalas.eu/php ${@:-"sh"}
}

function composer() {
    run zalas.eu/php composer ${@:-""}
}

function run() {
    container=${1:-""}
    command=${@:2}
    if [ "" == "$container" ]; then
      echo "Usage: $0 container_name [command]"
      exit 1
    fi
    if [ "" == "$command" ]; then
      command=sh
    fi
    docker run -it --rm \
        -v $(pwd):/zalas.eu \
        -v $HOME/.composer/cache:/root/.composer/cache \
        -w /zalas.eu \
        $container $command
}

function help() {
    USAGE="$0 "$(compgen -A function | tr "\\n" "|" | sed 's/|$//')
    echo $USAGE
}

if [ "$(type -t $COMMAND)" != "function" ]; then
    help
    exit 1
fi

$COMMAND ${@:2}
