---
author: Jakub Zalas
comments: true
date: 2009-07-02 17:34:16
layout: post
slug: symphony-cms-on-nginx
title: Symphony CMS on nginx
wordpress_id: 175
tags:
- configuration
- nginx
- php
- symphony
expired: true
---

I decided to give a [Symphony CMS](http://symphony-cms.com/) a try because of its XSLT templating system and structured approach in creating websites. As most of PHP applications it's running on apache out of the box. Since I preffer using [nginx](http://nginx.net/) I've encountered small problems with the configuration.

During the installation Symphony creates .htaccess file with rewrite definitions for clean URLs. Obviously it works only with apache and rewrites has to be translated into nginx' virtual host definition. Here is my fully working domain configuration for Symphony based websites (it should be included inside the http section):

```nginx
server {
  listen 80;
  server_name *.symphony.dev;
  root /var/www/$host/web;
  index index.php;

  access_log /var/log/nginx/symphony.dev-access.log;
  error_log /var/log/nginx/symphony.dev-error.log error;

  location / {
    # serve static files directly
    if (-f $request_filename) {
      access_log        off;
      expires           30d;
      break;
    }

    ### BACKEND
    if ($request_filename ~ /symphony/) {
      rewrite ^/symphony/(.*)$ /symphony/index.php?page=$1 last;
    }

    ### IMAGE RULES
    rewrite ^/image/(.+\.(jpg|gif|jpeg|png|bmp|JPG|GIF|JPEG|PNG|BMP))$ /extensions/jit_image_manipulation/lib/image.php?param=$1 last;

    ### CHECK FOR TRAILING SLASH - Will ignore files
    if (!-f $request_filename) {
        rewrite ^/(.*[^/]+)$ /$1/ permanent;
    }

    ### MAIN REWRITE - This will ignore directories
    if (!-d $request_filename) {
        rewrite ^/(.*)$ /index.php?page=$1 last;
    }
  }

  location ~ \.php($|/) {
    fastcgi_index index.php;

    set  $script     $uri;
    set  $path_info  "";
    if ($uri ~ "^(.+\.php)(/.*)") {
      set  $script     $1;
      set  $path_info  $2;
    }
    fastcgi_pass   127.0.0.1:9000;
    include /etc/nginx/fastcgi_params;
    fastcgi_param  SCRIPT_FILENAME  /var/www/$host/web/$script;
    fastcgi_param  PATH_INFO        $path_info;
    fastcgi_param  SCRIPT_NAME $script;
    fastcgi_param  SERVER_NAME $host;
  }

  location ~ /\.ht {
    deny  all;
  }
}
```

There is also *fastcgi_params* file need with configuration for fastcgi:

```nginx
fastcgi_param  QUERY_STRING       $query_string;
fastcgi_param  REQUEST_METHOD     $request_method;
fastcgi_param  CONTENT_TYPE       $content_type;
fastcgi_param  CONTENT_LENGTH     $content_length;

fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
fastcgi_param  REQUEST_URI        $request_uri;
fastcgi_param  DOCUMENT_URI       $document_uri;
fastcgi_param  DOCUMENT_ROOT      $document_root;
fastcgi_param  SERVER_PROTOCOL    $server_protocol;

fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;

fastcgi_param  REMOTE_ADDR        $remote_addr;
fastcgi_param  REMOTE_PORT        $remote_port;
fastcgi_param  SERVER_ADDR        $server_addr;
fastcgi_param  SERVER_PORT        $server_port;
fastcgi_param  SERVER_NAME        $host;

# PHP only, required if PHP was built with --enable-force-cgi-redirect
fastcgi_param  REDIRECT_STATUS    200;
```
