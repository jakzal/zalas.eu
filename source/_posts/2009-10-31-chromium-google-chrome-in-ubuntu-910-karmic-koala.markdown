---
author: Jakub Zalas
comments: true
date: 2009-10-31 06:06:37
layout: post
slug: chromium-google-chrome-in-ubuntu-910-karmic-koala
title: Chromium - Google Chrome in Ubuntu 9.10 (Karmic Koala)
wordpress_id: 284
tags:
- chrome
- chromium
- google
- installation
- ubuntu
expired: true
---

[Google Chrome](http://www.google.com/chrome) doesn't support Linux based operating systems yet. However, it is made on [Chromium](http://www.chromium.org/) which works on all major platforms. Chromium is an Open Source web browser with the same feature set as Google Chrome. Actually Google Chrome is based on Chromium. The only difference is the logo.

<div class="text-center">
    <a href="/uploads/wp/2009/10/chromium.png"><img src="/uploads/wp/2009/10/chromium-400x284.png" alt="Chromium - Google Chrome on Ubuntu 9.10 (Karmic Koala)" title="Chromium - Google Chrome on Ubuntu 9.10 (Karmic Koala)" class="img-responsive" /></a>
</div>

[Chromium daily builds](https://edge.launchpad.net/~chromium-daily/+archive/ppa) are available on [launchpad](https://launchpad.net/chromium-browser). Be aware that these builds are automated. That means packages are not tested and may be broken. However, I use these repositories since Ubuntu 9.04 and I hardly have problems with Chromium. As in **Ubuntu 9.10** the installation process became even simpler I encourage you to give it a try.

Since we use Karmic Koala manual edition of _/etc/apt/sources.list_ is no longer needed. Now we are able to add new sources and fetch required GPG keys with one command:

    
    sudo add-apt-repository ppa:chromium-daily


Than we simply refresh the package database and install Chromium Browser with:

    
    
    sudo aptitude update
    sudo aptitude install chromium-browser


There are no additional steps for flash support anymore. It just works.
