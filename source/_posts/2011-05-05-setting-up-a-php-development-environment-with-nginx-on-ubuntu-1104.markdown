---
author: Jakub Zalas
comments: true
date: 2011-05-05 13:46:26
layout: post
slug: setting-up-a-php-development-environment-with-nginx-on-ubuntu-1104
title: Setting up a PHP development environment with Nginx on Ubuntu 11.04
wordpress_id: 748
tags:
- configuration
- installation
- nginx
- php
- ubuntu
meta_keywords: php,nginx,configuration
expired: true
---

<div class="pull-left">
    <img src="/uploads/wp/2011/05/nginx-php.png" title="Nginx and PHP logo" alt="Nginx and PHP logo" class="img-responsive" />
</div>
I already described [how to prepare a PHP development environment with Nginx on Ubuntu 10.04](/setting-up-a-php-development-environment-with-nginx-on-ubuntu-1004/).

Ubuntu 11.04 (Natty Narwhal) simplifies the procedure a lot since **php-fpm** is available in the **PHP 5.3** core.

As I also managed to improve my **Nginx** configuration for PHP I decided to write on the subject again.


## PHP


Install PHP with chosen modules (whatever you need):

    
```bash
sudo apt-get install php5-fpm php5-cli php5-common php5-curl php5-gd \
  php5-mcrypt php5-mysql php5-pgsql php5-sqlite php5-tidy php5-xmlrpc \
  php5-xsl php5-intl php5-imagick php5-xdebug php-apc php-pear
```


<div class="alert alert-warning" markdown="1">
**Note**: Standard configuration is just fine to start with. In case you want to tweak it - all the PHP and php-fpm configuration files are located in the _/etc/php5/fpm_ directory.
</div>


## Nginx


Nginx installation is not complicated as well. Following command will install it with standard core modules:

    
```bash
sudo apt-get install nginx
```


I usually use fake domains for development (like _kuba.dev_ or _myproject.dev_). All virtual hosts are handled with a single configuration file _(/etc/nginx/sites-available/dev_):

    
```nginx
server {
    listen 80 default;
    server_name *.dev;

    root /var/www/$host/web;

    access_log /var/log/nginx/$host-access.log;
    error_log  /var/log/nginx/dev-error.log error;

    index index.php index.html index.htm;

    try_files $uri $uri/ @rewrite;

    location @rewrite {
        rewrite ^/(.*)$ /index.php/$1;
    }
    
    location ~ \.php {
        # try_files $uri =404;

        fastcgi_index index.php;
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


You need to enable the configuration:

    
```bash
sudo ln -s /etc/nginx/sites-available/dev /etc/nginx/sites-enabled/dev
```


<div class="alert alert-warning" markdown="1">
**Note**: I explained the Nginx directives and options in my another blog post ["Nginx configuration for Symfony projects](http://zalas.eu/nginx-configuration-for-symfony-projects/)".
</div>


## System configuration


To avoid using _sudo_ in the future you will need to make sure that files in the _/var/www_ directory can be altered by you. First add yourself to _www-data_ group and relogin:

    
```bash
sudo usermod -a -G www-data kuba
sudo su kuba
```


Then allow everyone in the __group__ to create virtual hosts:

    
```bash
sudo mkdir /var/www
sudo chown -R www-data:www-data /var/www
sudo chmod -R 775 /var/www
```


Define your domains in _/etc/hosts_ (this can be done much better with the [dnsmasq](http://http//www.thekelleys.org.uk/dnsmasq/doc.html) but for now hosts file should be sufficient):

    
    127.0.1.1 loki info.dev kuba.dev myproject.dev




## Tests


Create a test website:

    
```bash
mkdir /var/www/info.dev/web -p
echo "<?php echo phpinfo(); ?>" > /var/www/info.dev/web/index.php
chown -R :www-data /var/www/info.dev
chmod -R 775 /var/www/info.dev
```


Start php-fpm and Nginx services:

    
```bash
sudo service php5-fpm start
sudo service nginx start
```


Open _http://info.dev_ in your favorite browser. You should see a detailed information about your PHP installation.

<div class="text-center">
    <a href="/uploads/wp/2011/05/phpinfo.png"><img src="/uploads/wp/2011/05/phpinfo-400x367.png" title="phpinfo" alt="phpinfo" class="img-responsive" /></a>
</div>

