#!/usr/bin/env sh

set -e
set -x

./vendor/bin/sculpin generate --env prod
touch output_prod/.nojekyll