---
author: admin
comments: true
date: 2010-08-15 09:34:48
layout: post
slug: heard-in-the-community-20100815
title: Heard in the Community (2010.08.15)
wordpress_id: 551
tags:
- best practices
- php
- tdd
- wrap up
---

## Munchkin – Walking Skeleton and the initial stories


Munchkin is a [series of tutorials](http://alternateillusion.com/category/munchkin/) showing how to build a PHP project with the best programming practices in mind. As Author says: "_If you consider the average PHP world and average RPG, where the players are coders, then doing agile and TDD would definitely make you a power player who gets all the loot._".

Not in all cases I would use the same tools but it's not about copying the author. Tools doesn't matter as much as the proper approach he tries to teach us.

Up to now three articles were published:



	
  * [Munchkin a.k.a. learn greenfield TDD with PHP](http://alternateillusion.com/2010/07/22/munchkin-a-k-a-learn-greenfield-tdd-with-php/)

	
  * [Munchkin – Planning – User types](http://alternateillusion.com/2010/07/26/munchkin-planning-user-types/)

	
  * [Munchkin – Walking Skeleton and the initial stories](http://alternateillusion.com/2010/08/10/munchkin-walking-skeleton-and-the-initial-stories/)




## Your client doesn’t want to pay for unit tests and other quality measures? Don’t tell him!


[Christian Schaefer](http://twitter.com/testically) a.k.a testically is one of my favorite bloggers. His blog posts are really pleasant to read and he tends to choose interesting and unique topics.

Last week Christian advised to [hide unit tests from the client](http://test.ical.ly/2010/08/10/your-client-doesnt-want-to-pay-for-unit-tests-and-other-quality-measures-dont-tell-him/) in case he doesn't want to pay for them. I personally think unit testing and other quality assurance techniques are just part of our job and therefore cannot be offered as an "option".


## Quick Start Symfony DI (Dependency Injection) Tutorial


Dependency Injection is a sexy topic these days (not only in a PHP world). Symfony Dependency Injection Container is one of the best libraries letting you use DI in your project in an easy way. Steven Lloyd Watkin spend his time on writing [a quick start tutorial](http://www.evilprofessor.co.uk/264-quick-start-symfony-di-dependency-injection-tutorial/).

It's worth to mention that [Symfony DI Container](http://components.symfony-project.org/dependency-injection/) is a standalone library available as a [Symfony Component](http://components.symfony-project.org/). It can be successfully used without a symfony framework.


## Recursive Closures in PHP 5.3


PHP 5.2 active support [has ended recently](http://www.php.net/archive/2010.php#id2010-07-22-1). It's high time to move on towards PHP 5.3 and its new, mind-blowing features. Jeremy Cook shows you how to write [recursive closures](http://jeremycook.ca/2010/08/01/recursive-closures-in-php-5-3/) to keep your code clean and simple.


## phactory - a Database Factory for PHP Unit Tests


Creating fixtures for my tests is always a tedious and painful job. Doctrine's yml fixtures I use with symfony make this task a bit easier. [Phactory](http://phactory.org/) is a PHP library letting you to create fixture factories based on table blueprints.

I wouldn't use it instead of my yml fixtures yet but phactory is a definitely interesting project and I will track its development.


## HTML Sanitisation: The Devil's In The Details (And The Vulnerabilities)


HTML Sanitisation is definitely not an easy subject. I remember that before reading "[php|architect's Guide to PHP Security](http://www.goodreads.com/book/show/515875.php_architect_s_Guide_to_PHP_Security_)" I didn't even realize how hard a proper filtering of input might be. It's not something worth doing on your own.

Fortunately, there are quite a few PHP libraries doing just that. Pádraic Brady tested several still maintained projects and published the results on his blog: [HTML Sanitisation: The Devil's In The Details (And The Vulnerabilities)](http://blog.astrumfutura.com/archives/431-HTML-Sanitisation-The-Devils-In-The-Details-And-The-Vulnerabilities.html).

His really detailed analysis reveals the obvious winner of HTML Sanitisation in PHP: [HTMLPurifier](http://htmlpurifier.org/).
