---
author: Jakub Zalas
comments: true
date: 2011-04-28 22:14:44
layout: post
slug: nginx-configuration-for-symfony-projects
title: Nginx configuration for Symfony projects
wordpress_id: 735
tags:
- configuration
- nginx
- php
- symfony
- Symfony2
meta_keywords: Symfony,php,nginx,configuration
expired: true
---

<div class="pull-right">
    <img src="/uploads/wp/2011/04/nginx-symfony.png" title="Nginx and Symfony logos" alt="Nginx and Symfony logos" class="img-responsive" />
</div>
Recent release of Nginx 1.0.0 triggered me to refresh my knowledge about its configuration options. There were quite some additions since I looked in the docs for the last time. New variables and directives let me to simplify my configuration for Symfony projects (both 1.x and 2).

<div class="alert alert-warning" markdown="1">
**Warning:** Configurations published on the Internet usually suffer from the vulnerability which allows to run a non-PHP file as a PHP. More about the problem here: "[Setting up PHP-FastCGI and nginx? Don’t trust the tutorials: check your configuration!](https://nealpoole.com/blog/2011/04/setting-up-php-fastcgi-and-nginx-dont-trust-the-tutorials-check-your-configuration/)". For Nginx+PHP installation read "[Setting up a PHP development environment with Nginx on Ubuntu 11.04](http://zalas.eu/setting-up-a-php-development-environment-with-nginx-on-ubuntu-1104/)".
</div>


## Configuration


The convention says we should put virtual host configurations into */etc/nginx/sites-available/* directory and then link to them in */etc/nginx/sites-enabled/*.

Rules below define development virtual hosts. We'll put them into */etc/nginx/sites-available/dev* file.

    
```nginx
server {
    listen 80 default;
    server_name *.dev;

    root /var/www/$host/current/web;

    access_log /var/log/nginx/$host-access.log;
    error_log  /var/log/nginx/dev-error.log error;

    index app.php index.html index.htm;

    try_files $uri $uri/ @rewrite;

    location @rewrite {
        rewrite ^/(.*)$ /app.php/$1;
    }

    location ~ \.php {
        # try_files $uri =404;

        fastcgi_index app.php;
        fastcgi_pass 127.0.0.1:9000;

        include fastcgi_params;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }

    location ~ /\.ht {
        deny all;
    }
}
```


Don't forget about the symbolic link (*/etc/nginx/sites-enabled/dev*).


## More about the configuration



    
```nginx
    listen 80 default;
```


Nginx listens on the port 80 by default. What's important in this line is the second parameter - "default". It makes that Nginx treats given host as a default one.

    
```nginx
    server_name *.dev;
```


Our dynamic virtual host will accept every *.dev* domain (*kuba.dev*, *myproject.dev* etc).

Alternatively we could simply list one ore more domains (i.e. *server_name zalas.eu*). In such case we'd probably define every domain in a separate _server {}_ section.

    
```nginx
    root /var/www/$host/current/web;
```


Root directory will be defined dynamically based on the *$host* variable (*/var/www/kuba.dev/current/web* for *kuba.dev* domain).

    
```nginx
    access_log /var/log/nginx/$host-access.log;
    error_log  /var/log/nginx/dev-error.log error;
```


Every domain will have its own access log. Unfortunately we cannot use _$host_ variable with error logs. Therefore all the errors will be logged into the same file.

    
```nginx
    index app.php index.html index.htm;
```


Index files are checked every time URL points to the directory. Nginx will try them one by one until it finds an existing one.

*app.php* is a default controller in Symfony2. For symfony 1.x it's usually _index.php_.

    
```nginx
    try_files $uri $uri/ @rewrite;
```


It's a really elegant solution for readable URLs as it lets us to [avoid evil if statements](http://wiki.nginx.org/IfIsEvil).

During the request Nginx will check for an existence of a file first. If the file doesn't exist it will look for a directory. If both checks fail it will rewrite the request to the _named location_.

    
```nginx
    location @rewrite {
        rewrite ^/(.*)$ /app.php/$1;
    }
```


This named location is reached only if user wasn't requesting an existing file or directory. We want to rewrite such a request to the default controller.

    
```nginx
    location ~ \.php {
        fastcgi_index app.php;
        fastcgi_pass 127.0.0.1:9000;

        include fastcgi_params;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
```


All the PHP requests will be routed to the fastcgi deamon (running locally on port 9000).

Appart from including default fastcgi parameters we make sure that PATH_INFO and SCRIPT_FILENAME variables are set properly. *fastcgi_split_path_info* says how to split the controller file from the path.

    
```nginx
    location ~ /\.ht {
        deny all;
    }
```


This will forbid access to apache's *.htaccess* files. These are only simple text files for Nginx and we don't want them to be accessible via the browser.


