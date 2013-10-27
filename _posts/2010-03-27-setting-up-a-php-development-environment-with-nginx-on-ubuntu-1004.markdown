---
author: Jakub Zalas
comments: true
date: 2010-03-27 04:59:34
layout: post
slug: setting-up-a-php-development-environment-with-nginx-on-ubuntu-1004
title: Setting up a PHP development environment with nginx on Ubuntu 10.04
wordpress_id: 381
tags:
- configuration
- installation
- nginx
- php
- ubuntu
---

<div class="pull-left">
    <img src="/uploads/wp/2010/03/nginx-logo.png" title="Nginx Logo" alt="Nginx Logo" class="img-responsive" />
</div>
[Nginx](http://wiki.nginx.org/) is a lightweight http, proxy and load balancing server. It's a **serious alternative** for a widely used **apache**. Most important advantages of nginx on a production environments are **speed** and small amount of **memory** it uses. In a development environment I really like the simple and flexible **configuration**.

Here's a guide how to quickly prepare **PHP development environment** with **nginx** on **Ubuntu** 10.04 (Lucid Lynx).

<div class="alert alert-warning" markdown="1">**Note:** I updated this article for Ubuntu 11.04. Read "[Setting up a PHP development environment with Nginx on Ubuntu 11.04](../../../setting-up-a-php-development-environment-with-nginx-on-ubuntu-1104)" if you're using a new release of Ubuntu.</div>


## PHP


Install PHP with chosen modules:

    
{% highlight bash %}
sudo aptitude install php5-cgi php5-cli php5-common php5-curl php5-gd \
  php5-imagick php5-json php5-mcrypt php5-mysql php5-pgsql php5-sqlite \
  php5-xmlrpc php5-xsl php5-xdebug php-apc
{% endhighlight %}




## Spawn FCGI


Install spawn-fcgi script:

{% highlight bash %}
sudo aptitude install spawn-fcgi
{% endhighlight %}


Copy the [init script](http://github.com/jakzal/php-cgi/raw/master/etc/init.d/php-cgi) to _/etc/init.d/php-cgi_:

    
{% highlight nginx %}
#! /bin/sh

### BEGIN INIT INFO
# Provides:          php-cgi
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: spawns the php-cgi
# Description:       spawns the php-cgi
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
NAME=php-cgi
DESC=php-cgi

test -x $DAEMON || exit 0

PIDFILE="/var/run/$NAME.pid"
DAEMON="/usr/bin/php-cgi"
SPAWN_FCGI="/usr/bin/spawn-fcgi"
FCGI_PORT=9000
FCGI_USER="www-data"
FCGI_GROUP="www-data"
FCGI_CHILDREN=0

# Include php-cgi defaults if available
if [ -f /etc/default/php-cgi ] ; then
        . /etc/default/php-cgi
fi

SPAWN_FCGI_OPTS="-f $DAEMON -a 127.0.0.1 -p $FCGI_PORT -u $FCGI_USER -g $FCGI_GROUP -C $FCGI_CHILDREN -P $PIDFILE"

set -e

. /lib/lsb/init-functions

case "$1" in
  start)
        echo -n "Starting $DESC: "
        start-stop-daemon --start --quiet --pidfile $PIDFILE --exec "$SPAWN_FCGI" -- $SPAWN_FCGI_OPTS || true
        echo "$NAME."
        ;;
  stop)
        echo -n "Stopping $DESC: "
        start-stop-daemon --stop --quiet --pidfile $PIDFILE --exec "$DAEMON" || true
        echo "$NAME."
        ;;
  restart)
        echo -n "Restarting $DESC: "
        start-stop-daemon --stop --quiet --pidfile $PIDFILE --exec "$DAEMON" || true
        sleep 1
        start-stop-daemon --start --quiet --pidfile $PIDFILE --exec "$SPAWN_FCGI" -- $SPAWN_FCGI_OPTS || true
        echo "$NAME."
        ;;
  status)
        status_of_proc -p $PIDFILE "$DAEMON" php-cgi && exit 0 || exit $?
        ;;
  *)
        echo "Usage: $NAME {start|stop|restart|status}" >&2
        exit 1
        ;;
esac

exit 0
{% endhighlight %}


And allow to execute it:

    
{% highlight bash %}
sudo chmod +x /etc/init.d/php-cgi
{% endhighlight %}


Put the [configuration](http://github.com/jakzal/php-cgi/raw/master/etc/default/php-cgi) to _/etc/default/php-cgi_:

    
{% highlight bash %}
PIDFILE="/var/run/php-cgi.pid"
DAEMON="/usr/bin/php-cgi"
SPAWN_FCGI="/usr/bin/spawn-fcgi"
FCGI_PORT=9000
FCGI_USER="www-data"
FCGI_GROUP="www-data"
FCGI_CHILDREN=0
{% endhighlight %}


<div class="alert alert-warning" markdown="1">**Note**: You will find most recent version of my init scripts on github: [http://github.com/jakzal/php-cgi](http://github.com/jakzal/php-cgi).</div>


## Nginx


Install the nginx:

    
{% highlight bash %}
sudo aptitude install nginx
{% endhighlight %}


Save the following configuration file as a _/etc/nginx/sites-available/dev.conf_:

    
{% highlight nginx %}
server {
  listen 80;
  server_name *.dev;
  root /var/www/$host/web;

  access_log /var/log/nginx/$host.access.log;
  error_log /var/log/nginx/error.log error;

  location / {
    root   /var/www/$host/web/;
    index  index.php;

    # serve static files directly
    if (-f $request_filename) {
      access_log        off;
      expires           30d;
      break;
    }

    rewrite ^(.*) /index.php last;
  }

  location ~ \.php {
    fastcgi_index  index.php;

    set  $script     $uri;
    set  $path_info  "";
    if ($uri ~ "^(.+\.php)(/.*)") {
      set  $script     $1;
      set  $path_info  $2;
    }
    fastcgi_pass   127.0.0.1:9000;
    include /etc/nginx/fastcgi_params;
    fastcgi_param  SCRIPT_FILENAME  /var/www/$host/web$script;
    fastcgi_param  PATH_INFO        $path_info;
    fastcgi_param  SCRIPT_NAME $script;
  }

  location ~ /\.ht {
    deny  all;
  }
}
{% endhighlight %}


And make it available for nginx:

    
{% highlight bash %}
sudo ln -s /etc/nginx/sites-available/dev.conf /etc/nginx/sites-enabled/dev.conf
{% endhighlight %}



## System configuration


Add yourself to _www-data_ group and relogin:

    
{% highlight bash %}
sudo usermod -a -G www-data kuba
sudo su kuba
{% endhighlight %}


Allow everyone in _www-data_ group to edit websites:

    
{% highlight bash %}
sudo chown -R www-data:www-data /var/www
sudo chmod -R 775 /var/www
{% endhighlight %}


Define your domains in _/etc/hosts_ (this can be done much better with a [dnsmasq](http://http://www.thekelleys.org.uk/dnsmasq/doc.html) but for now it should be sufficient):

    
    127.0.0.1 localhost info.dev myproject.dev


Create your first website:

    
{% highlight bash %}
mkdir /var/www/info.dev/web -p
echo "<?php echo phpinfo(); ?>" > /var/www/info.dev/web/index.php
chown -R :www-data /var/www/info.dev
chmod -R 775 /var/www/info.dev
{% endhighlight %}


Start php-cgi and nginx services:

    
{% highlight bash %}
sudo service php-cgi start
sudo service nginx start
{% endhighlight %}


Open http://info.dev in your browser. We've just configured PHP to work with nginx.
