---
author: Jakub Zalas
comments: true
date: 2010-08-01 13:39:58
layout: post
slug: heard-in-the-community-20100801
title: Heard in the Community (2010.08.01)
wordpress_id: 531
tags:
- oop
- php
- symfony
- Symfony2
- wrap-up
---

## Symfony2


Symfony2 development moves forward quickly. Last week the [API documentation](http://api.symfony-reloaded.org/PR2/) was generated and put online by [Fabien Potencier](http://twitter.com/fabpot). Also, the [translation process](http://docs.symfony-reloaded.org/contributing/documentation/translations.html) is now described so translators can start contributing.

[Kris Wallsmith](http://twitter.com/kriswallsmith) wrote a short introduction to Symfony2 helpers: [How to create a Symfony2 templating helper](http://kriswallsmith.net/post/878278731/how-to-create-a-symfony2-templating-helper). Finally helpers are implemented as classes!


## symfony application in 26 minutes


Want to see an application built in 26 minutes? [Tom Boutell](http://twitter.com/tommybgoode) posted [Symfony Almost Live](http://window.punkave.com/2010/07/30/symfony-almost-live/) screencast on punk'd avenue window showing just that. It's a good introduction for newbies in a symfony framework.


## OOP in scripting languages


I accidentally came across a blog post titled [Do Web-Scripting Languages Really Need OOP?](http://iamlearningphp.blogspot.com/2010/07/do-web-scripting-languages-really-need.html) I also found an answer to that question on [Invisible to the eye](http://giorgiosironi.blogspot.com) blog: [Missing the point (OOP in scripting languages)](http://giorgiosironi.blogspot.com/2010/07/missing-point-oop-in-scripting.html). I totally agree with the later.


## Features in PHP trunk: Array dereferencing


[Array dereferencing ](http://schlueters.de/blog/archives/138-Features-in-PHP-trunk-Array-dereferencing.html)is a new feature which just got into the PHP trunk. It allows you to do stuff like:

    
```php
function getData() {
  return array(1, 2, 3);
}

echo getData()[1];
```

Hopefully it'll also work with native PHP functions.
