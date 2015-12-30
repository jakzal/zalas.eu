---
author: Jakub Zalas
comments: true
date: 2011-02-06 14:36:07
layout: post
slug: setting-up-a-bleeding-edge-symfony2-project
title: Setting up a bleeding edge Symfony2 project
wordpress_id: 563
tags:
- git
- onTheEdge
- php
- Symfony2
expired: true
---

[Symfony2](http://symfony-reloaded.org/) is not ready yet. Since the release is planned for March this year and I just can't wait any longer I started to play with it more seriously.

I also want to know all those nitty-gritty details. Therefore I didn't go for sandbox and decided to generate a fresh project.

<div class="alert alert-warning" markdown="1">
**Warning:** symfony-bootstrapper described in this article is deprecated and not mainained anymore.
</div>

There are already several articles describing the process using the [symfony-bootstrapper](https://github.com/symfony/symfony-bootstrapper):

* [Make your own Symfony2 sandbox (the easy way)](http://www.webpragmatist.com/2010/11/make-your-own-symfony2-sandbox.html) (by [@webPragmatist](http://twitter.com/webPragmatist))
* [Symfony2 project initialization](http://blog.bearwoods.dk/symfony2-project-initilization) (by [@henrikbjorn](http://twitter.com/henrikbjorn))
* [Symfony2 project from scratch](http://www.fizyk.net.pl/blog/symony2-project-from-scratch)


Symfony2 internals are being changed every day. For someone who wants to be always up to date I think it's better to utilize [git submodules](http://progit.org/book/ch6-6.html) for vendor libraries. Here is slightly modified process of generating your own Symfony2 project.

Let's start with getting the Symfony2 bootstrapper:

    
```bash
    git clone git://github.com/symfony/symfony-bootstrapper.git ~/workspace/lib/Symfony2-bootstrapper
```


We'll need a project directory and a git repository as well:

    
```bash
mkdir ~/workspace/projects/FooBar
cd ~/workspace/projects/FooBar
git init .
```


Finally we can initialize a Symfony2 project so the basic directory structure is in place:

    
```bash
cd ~/workspace/projects/FooBar
php ~/workspace/lib/Symfony2-bootstrapper/symfony.phar init --name 'FooBar' --format="yml"
git add app/ src/ web/
git commit -m 'Bootstrapped Symfony2 application.'
```


Last but not least we'll install Symfony2 and other vendor libraries as a git submodules:

    
```bash
cd ~/workspace/projects/FooBar
git submodule add git://github.com/symfony/symfony.git src/vendor/symfony
cat src/vendor/symfony/install_vendors.sh | grep "git clone" | awk '{print "git submodule add "$3" src/vendor/"$4}' | while read line; do $line; done
git commit -m 'Added vendor submodules.'
```


<div class="alert alert-warning" markdown="1">
**Note**: At the moment of writing this there's a [small bug in the bootstrapper](https://github.com/symfony/symfony-bootstrapper/issues#issue/10).  Recently the [UniversalClassLoader was moved to its own component](https://github.com/symfony/symfony/commit/42f9c556a35af616d3239df64f42c15b98602472) and it's not yet changed in the bootstrapper (both in the source code and the phar archive). I committed [a fix](https://github.com/jakzal/symfony-bootstrapper/commit/61abd3eb571b238783218b6f675f4baf59cbcf66) but my [pull request](https://github.com/symfony/symfony-bootstrapper/pull/10) is not yet merged. By the time it happens you can simply modify a path in the _src/autoload.php_ of generated project (replace _HttpFoundation_ with _ClassLoader_ in a path to UniversalClassLoader.php).
</div>
