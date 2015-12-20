#!/usr/bin/env sh

set -e
set -x

cd output_prod

if [ -d ".git" ]; then
    rm -rf .git
fi

git init

git config user.email 'jakub@zalas.pl'
git config user.name 'Jakub Zalas'

git add .
git commit -m "Build the website"

git push --force --quiet "https://github.com/jakzal/zalas.eu.git" master:gh-pages