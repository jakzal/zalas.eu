---
author: admin
comments: true
date: 2010-07-25 13:04:29
layout: post
slug: heard-in-the-community-20100725
title: Heard in the Community (2010.07.25)
wordpress_id: 490
tags:
- best practices
- php
- Symfony2
- WordPress
- wrap up
---

"Heard in the Community" series aims to wrap up news from the PHP, symfony and other communities I find interesting and follow.

Here's the first post.


## Protect your privates


![Symfony2](/uploads/wp/2010/07/mini_logo.png)[Symfony2 coding standards](http://symfony-reloaded.org/contributing/Code/Standards) favor public and protected access modifiers over private. Blog post by Lukas started hot discussion on this subject in the community (on twitter and blogs):



	
  * [Red tape and the art of ripping through it](http://pooteeweet.org/blog/1799/1799#m1799) by [Lukas Smith](http://twitter.com/dybvandal)

	
  * [My privates are not public, they are protected](http://www.leftontheweb.com/message/My_privates_are_not_public_they_are_protected) by [Stefan Koopmanschap](http://twitter.com/skoop)

	
  * [Good use of public, private and protected in OO class design](http://www.jansch.nl/2010/07/19/good-use-of-public-private-and-protected-in-oo-class-design/) by [Ivo Jansch](http://twitter.com/ijansch)


While I think that all methods should be as private as possible I can understand points made in the listed blog posts. I guess coding an Open Source framework might need different approach. In everyday work, however, I believe it's a good practice to make the **main responsibility of a class public** and its **internals private or protected**.


## PHP4 is dead (again)


![WordPress](/uploads/wp/2010/07/grey-s.png) Over 3 years ago [PHP4 end of life announcement](http://www.php.net/archive/2007.php#2007-07-13-1) was published. Despite its death PHP4 is still hanging around like a zombie. Some of the popular Open Source projects keep supporting it. WordPress is one of the last projects to [announce end of support for PHP4](http://wordpress.org/news/2010/07/eol-for-php4-and-mysql4/). Finally I'd say.


## PHP 5.3.3 Was Released


![PHP](/uploads/wp/2010/05/php-med-trans-light.gif)Both PHP **5.3.3** and **5.2.14** [were released](http://www.php.net/archive/2010.php#id2010-07-22-2) with many bug and security fixes. I'm really happy to read that [FPM](http://php-fpm.org/) (FastCGI Process Manager) SAPI is now available in the PHP out of the box.


## An entirely unscientific look at why people attend conferences


I mainly attend conferences to **network** and find **inspiration**. [Cal Evans](http://twitter.com/calevans) asked group of developers and managers [why people attend conferenes](http://blog.calevans.com/2010/07/19/an-entirely-unscientific-look-at-why-people-attend-conferences/) and gathered quite an interesting results.
