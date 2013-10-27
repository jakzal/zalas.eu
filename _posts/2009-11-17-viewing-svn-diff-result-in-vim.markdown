---
author: Jakub Zalas
comments: true
date: 2009-11-17 07:02:43
layout: post
slug: viewing-svn-diff-result-in-vim
title: Viewing svn diff result in vim
wordpress_id: 310
tags:
- bash
- svn
- vim
---

Some time ago I explained [how to use colordiff to display svn diff's result in colors](/viewing-svn-diff-result-in-colors). You can do pretty the same with **vim**. It is specially useful when you have big amount of code to commit and it needs to be reviewed first. Vim makes navigating through it easier.

<div class="text-center">
    <a href="/uploads/wp/2009/11/vim-diff.png"><img src="/uploads/wp/2009/11/vim-diff-400x168.png" title="Viewing svn diff in vim" alt="Viewing svn diff in vim" class="img-responsive" /></a>
</div>

To view svn diff output in vim run:

{% highlight bash %}
svn diff lib/zWebBrowser.class.php | view -
{% endhighlight %}

_view_ opens vim session in read only mode. This way you won't be asked whether you want to save the file on exit.

As you're going to use this command often, it's better to wrap it as a bash function. Add lines below to your _~/.bashrc_ file to load the function during login.

{% highlight bash %}
svndiff()
{
  svn diff "${@}" | view -
}
{% endhighlight %}


It will make the command shorter:

{% highlight bash %}
svndiff lib/zWebBrowser.class.php
{% endhighlight %}
