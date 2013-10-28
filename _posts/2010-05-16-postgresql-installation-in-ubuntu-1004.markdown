---
author: Jakub Zalas
comments: true
date: 2010-05-16 00:01:17
layout: post
slug: postgresql-installation-in-ubuntu-1004
title: PostgreSQL installation in Ubuntu 10.04
wordpress_id: 470
tags:
- installation
- php
- postgresql
- ubuntu
---

<div class="pull-left">
    <img src="/uploads/wp/2010/05/postgresql.png" title="PostgreSQL" alt="PostgreSQL" class="img-responsive" />
</div>

[PostgreSQL](http://www.postgresql.org/) is a powerful and reliable object-relational database system. It's a great alternative for MySQL. It is as easy to set up, performs better and offers far more features.

To install PostgreSQL server run:

    
    sudo aptitude install postgresql


Database users can be created in command line with _createuser_ tool.        Running the following command will create user 'kuba' who is not a superuser, can  create databases, cannot create new roles and his password is stored encrypted. You will be asked to give new user's password as '-P' option is passed.

    
    sudo su postgres -c 'createuser -S -d -R -E -P kuba'


<div class="alert alert-warning" markdown="1">**Note**: Run _createuser_ with _--help_ switch to get an overview of available options.</div>

There is a similar tool for database creation called createdb:

    
    createdb mydatabase


<div class="alert alert-warning" markdown="1">**Note**: Read about MySQL in my another post: [MySQL installation in Ubuntu 10.04](/mysql-installation-in-ubuntu-1004).</div>
