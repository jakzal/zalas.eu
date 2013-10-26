---
author: admin
comments: true
date: 2009-07-01 23:47:13
layout: post
slug: caching-the-websites-with-bash-script-and-apaches-htaccess-file
title: Caching the websites with bash script and apache's .htaccess file
wordpress_id: 143
tags:
- apache
- bash
- best-practices
- cache
- htaccess
- script
---

Recently I got a task to make a completely inefficient application usable enough to give the development team time for improvements. I didn't know the application and didn't have sufficient time to learn it. In that completely miserable moment I was left alone.

Main cause of high load on the server was too many additional requests made by already loaded website.  Requests where made for XML files which in most cases where very expensive to create and didn't change to often. Ideal candidates for caching you might think. As my solution was suppose to be only temporary and I had to implement it fast, I came up with simple bash script which did the job flawlessly.

The script analyses webserver's log files (in this case apache) and looks for URLs which are supposed to be cached. Once URL is found it's stored on the disk. Next requests get the file directly without any calculations. Here is the full code:

    
    #!/bin/bash
    
    # CONFIG
    base_path="/var/www/heavyloadedapp.com/web"
    xml_path="/var/www/heavyloadedapp.com/web/cache-xml"
    url="http://heavyloadedapp.com"
    paths=$(cat /var/log/httpd/heavyloadedapp.com.log | grep XML | less | awk '{print $7}' | sort | uniq)
    user="apache"
    rights="755"
    # CONFIG END
    
    if [ ! -d $xml_path ]; then
      mkdir $xml_path
    fi
    
    cd $xml_path
    
    for path in $paths; do
      rel_path=$(echo $path | sed -e 's/^\///' | sed -e 's/^\(.*\)?\(.*\)$/\1/')
      if [ ! -f $rel_path ]; then
        if [ $(echo "$rel_path" | grep -E '\/') ]; then
          dir=$(echo $rel_path | sed -e 's/\(.*\)\/.*/\1/')
          mkdir -p $dir
        fi
        /usr/bin/wget -U "CacheBrowser" -nv $url/$rel_path -O $rel_path
      fi
    done
    
    chown -R $user $xml_path
    chmod -R $rights $xml_path
    
    cd -


At the top of it you can find configuration options. It's needed to set path to the application's code, cache directory and the base URL. _$paths_ variable stores the list of paths found in the log file. I used grep to get all paths with 'XML' in it, then sorted it and filtered to get every path only once. This part has to be adapted to the problem that needs to be solved. Grep should only catch pages or documents you want to be cached.

Later the script loops through found URLs (paths) and checks if they are not yet saved. New documents are stored in the cache directory (_cache-xml_ in this case). It's as simple as that. Second time given URL is requested following rules in _.htaccess_ file are responsible for rewriting the URL to the location of physical file:

    
    RewriteEngine On
    RewriteBase /
    
    ### XML Caching ###
    RewriteCond %{REQUEST_URI} ^(.*XML.*)$
    RewriteCond %{REQUEST_URI} !^.*cache-xml(.*)$
    RewriteCond %{DOCUMENT_ROOT}/cache-xml%1 -f
    RewriteCond %{HTTP_USER_AGENT} !CacheBrowser
    RewriteRule .* cache-xml%1 [L]
    ### XML Caching END ###


In the script, while using wget, I change the User Agent to _CacheBrowser_. Thanks to that I can recognize its requests in _.htaccess_ file and treat it in a different way than usual requests.

That's all. First time URL is visited it's made visible in the log file. Script, which runs as a cron job, finds new URLs and stores the documents on filesystem. Next time URL is visited the application is not even run. **Nothing is more efficient than serving static files.**


## Where's the catch?


Solution is simple and works great but there are few drawbacks.

First of all once file is saved it's not refreshed. Cache never expires. Refreshing could be done in two ways. We can either clear the cache automatically (once per time) or clear it in the application (once something cahanges or on demand). While first solution is as easy as adding proper cron job, it's rarely preferred one. User wants to see the results instantly after he changes the content. Unfortunately it's strictly depending on technology being used.

Second problem becomes visible when we have different versions of page for authorized and non-authorized Users. We just cannot cache such documents without checking User's credentials. The line which gets paths from the log file should be modfied in such a way to reject the pages which require User to be logged in.


## Conclusion


To often programmers tend to forget about caching content which is expensive to generate or doesn't change for a while. Furthermore, good practise while creating high demanding websites is limiting the number of http requests. Describing this real life example I hoped to show that efficient caching doesn't have to be a complicated solution. On the other hand trying to cache dynamic pages we face real problems which usually have to be solved independently. **Choosing proper tool is really important.** Mentioned application was not written in technology that delivers tools to implement caching in short time.
