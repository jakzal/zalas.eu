---
author: Jakub Zalas
comments: true
date: 2010-05-03 04:16:43
layout: post
slug: reply-to-php-53-and-the-future
title: Reply to PHP 5.3 and the Future
wordpress_id: 440
tags:
- php
- symfony
---

<div class="pull-left">
    <a href="/uploads/wp/2010/05/php-med-trans-light.gif"><img src="/uploads/wp/2010/05/php-med-trans-light.gif" title="PHP" alt="PHP" class="img-responsive" /></a>
</div>

Mark Evans wrote on his blog interesting post about [PHP 5.3 and the Future](http://www.freelancephp.co.uk/2010/05/02/php-5-3-and-the-future/). I guess the main concern   here is similar we used to have with **PHP4** to **PHP5** migration ([GoPHP5 campaign](http://www.gophp5.org/)).

Mark raised three questions to the community which I'd like to reply to.


## How can the migration path for shared hosting companies be made easier?


For some time **PHP 5.2** will still be in use. Therefore hosting companies simply cannot afford dropping support for it. There are many popular PHP applications which   are not yet ready for **PHP 5.3** (consider Drupal).

However, it's not a big deal to install both PHP 5.2 and 5.3 on the same server and let the customers choose. I've seen it working with PHP 4 and 5. It's even easier with PHP 5.2 and 5.3. It's possible and it's simple.

Furthermore, migrating [PHP 5.2 application to 5.3](http://www.php.net/manual/en/migration53.php) is not as hard as one would think. Most of PHP frameworks are already updated. **In my opinion adaptation will be a lot faster than in case PHP 4 to 5**.

However, you should remember that PHP 5.3 applications will be designed differently. With PHP 5.3 you get a number of [new features](http://php.net/manual/en/migration53.new-features.php) which give a lot of power and affect the application's architecture (like [namespaces](http://php.net/manual/en/language.namespaces.php)). Even if you can run old applications on PHP 5.3 sooner or later they will become a legacy you want to get rid of.


## If you were writing a new open-source application would you go purely 5.3+?


Definitely yes. Starting a new Open Source project in the PHP 5.2 now, when 5.3 release is more than ready, will make the project live shorter. While all the future  applications will head for clear, namespaced structure, yours will still have old-school design.

**Someday you'll have to either migrate or rewrite it.**

Besides, I don't want to stick to the technology which is headed for extinction. Web development is a very dynamic word. **If you cannot adapt to the new trends you're moving backwards.** Starting a new Open Source project is a great way to learn all the new features of PHP 5.3.

You could be concerned that application written in PHP 5.3 wouldn't gain a lot of users because of slow adaptation of PHP 5.3 by hosting companies. Well, if the            application is good enough users want to have it no matter what. **They will go to the early adapting hosting companies**. Sooner or later others will be forced to       upgrade their servers as well. And as I wrote before it's not a hard task so it should go rather fast.


## Do you know of any other open-source applications requiring 5.3+?


There are plans to [build phpBB4 based on Symfony 2](http://area51.phpbb.com/phpBB/viewtopic.php?f=78&t=32433). This is actually the only application requiring PHP 5.3 I know.

However, there are some frameworks which will support PHP 5.3+ only:



	
  * [Symfony 2](http://symfony-reloaded.org/)

	
  * [Doctrine 2](http://www.doctrine-project.org/)

	
  * [Zend 2](http://framework.zend.com/wiki/display/ZFDEV2/Zend+Framework+2.0+Roadmap)

	
  * [Lithium](http://rad-dev.org/lithium)


