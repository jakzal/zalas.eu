---
author: Jakub Zalas
comments: true
date: 2009-05-30 03:02:13
layout: post
slug: chromium-google-chrome-in-ubuntu-904
title: Chromium - Google Chrome in Ubuntu 9.04
wordpress_id: 118
tags:
- chrome
- chromium
- google
- installation
- ubuntu
---

[Chromium](http://chromium.org/) is a project aiming to run Google Chrome web browser on Linux. [Launchpad](https://launchpad.net/chromium-project) repositories deliver [apt sources list](https://launchpad.net/~chromium-daily/+archive/ppa) for Ubuntu which enables us with an easy installation process like usual: add sources and authorization key, update package database and install the application.

<div class="alert alert-warning" markdown="1">**Note**: For simpler installation instructions on Ubuntu 9.10 (Karmic Koala) read my new blog post "[Chromium - Google Chrome in Ubuntu 9.10 (Karmic Koala)](/chromium-google-chrome-in-ubuntu-910-karmic-koala)".</div>


<div class="text-center">
    <a href="/uploads/wp/2009/05/chromium-goyello.png"><img src="/uploads/wp/2009/05/chromium-goyello-400x291.png" alt="Chromium" title="Chromium" class="img-responsive" /></a>
</div>



First we need to add Chromium application sources for Ubuntu Jaunty Jackalope.

    
    deb http://ppa.launchpad.net/chromium-daily/ppa/ubuntu jaunty main
    deb-src http://ppa.launchpad.net/chromium-daily/ppa/ubuntu jaunty main


To connect to the servers we need authentication keys. It's possible with simple apt command.

    
    sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0x5a9bf3bb4e5e17b5


Now we need to refresh information about the packages.

    
    sudo aptitude update


Finally we can install Chromium.

    
    sudo aptitude install chromium-browser


In case you need flash support, first make sure it's installed:

    
    sudo aptitude install flashplugin-nonfree


Next we need to copy flash plugin into proper directory so Chromium could find it:

    
    sudo cp /usr/lib/flashplugin-installer/libflashplayer.so /usr/lib/chromium-browser/plugins/


Last but not least, to enable flash, Chromium needs to be run with plugins enabled:

    
    chromium-browser --enable-plugins
