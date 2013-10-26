#!/bin/sh

posts_dir="_posts"
tags_dir="tag"
tag_file=$(cat <<EOF
---
layout: tags
title: Pages labeled with "%TAG%"
tag: %TAG%
---
EOF
);

tags=$(
    pcregrep -r -h -M 'tags:\n(^[-]\s+.*\n)*' "$posts_dir" |
    grep -v 'tags' |
    sed -e 's/^- *\(.*\)/\1/g' |
    sed -e 's/ /-/g' |
    sort -u
)

for tag in $tags; do
    mkdir -p $tags_dir/$tag
    echo "$tag_file" | sed -e 's/%TAG%/'$tag'/g' > $tags_dir/$tag/index.html
done

