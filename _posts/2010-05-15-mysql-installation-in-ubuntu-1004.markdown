---
author: admin
comments: true
date: 2010-05-15 13:45:01
layout: post
slug: mysql-installation-in-ubuntu-1004
title: MySQL installation in Ubuntu 10.04
wordpress_id: 464
tags:
- installation
- mysql
- php
- ubuntu
---

![MySQL](/uploads/wp/2010/05/logo-mysql-110x57.png)[MySQL](http://www.mysql.com/) is one of the most popular relational database systems which is widely used with PHP applications. It's relatively easy to set up and use. Here's a quick guide of how to install and configure MySQL in the newest release of Ubuntu.

First install the MySQL server:

    
    sudo aptitude install mysql-server


The installer will ask you for a root password. Using root user, however, is    not the best practice. It's way better to give yourself permissions to create   and use databases.

First open MySQL console:

    
    mysql -p -u root


Next, grant yourself all priviledges for localhost connections (replace 'kuba'  with your user name and password with password of your preference):

    
    GRANT ALL PRIVILEGES ON *.* TO kuba@'localhost' IDENTIFIED BY 'my$ecret';
    \q


Now you can create MySQL databases without the need of using root account:

    
    mysqladmin -p create wordpress


**Note**: Read about PostgreSQL in my another post: [PostgreSQL installation in Ubuntu 10.04](/postgresql-installation-in-ubuntu-1004).
