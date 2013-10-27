---
author: Jakub Zalas
comments: true
date: 2009-06-16 21:18:07
layout: post
slug: viewing-svn-diff-result-in-colors
title: Viewing svn diff result in colors
wordpress_id: 134
tags:
- installation
- linux
- svn
- ubuntu
---

_svn diff_ allows us to see the changes made on the files in the subversion repository. However, its output  is not always clear. New lines are just marked with '+' and removed ones with '-'.


<div class="text-center">
    <a href="/uploads/wp/2009/06/svn-diff-before.png"><img src="/uploads/wp/2009/06/svn-diff-before-399x183.png" title="svn diff in black and white" class="img-responsive" /></a>
</div>

We can improve our experience a bit by installing [colordiff](http://colordiff.sourceforge.net/). It wraps _diff_ command and produces the same output but coloured.

<div class="text-center">
    <a href="/uploads/wp/2009/06/svn-diff-after.png"><img src="/uploads/wp/2009/06/svn-diff-after-400x183.png" title="svn diff in colors" class="img-responsive" /></a>
</div>


In ubuntu it's as simple as running:

{% highlight bash %}
sudo aptitude install colordiff
{% endhighlight %}


Once doing that we should be able to redirect the output of commands like _diff_ and _svn diff_ to colordiff and view it in colors:

{% highlight bash %}
svn diff plugins/zMobyPicturePlugin/lib/zMobyPictureClient.class.php | colordiff
{% endhighlight %}


To improve it even more we can declare simple function in _~/.bashrc_ file (using it requires re-login):

    
{% highlight bash %}
svndiff()
{
  svn diff "${@}" | colordiff
}
{% endhighlight %}


Function will make the command shorter:

{% highlight bash %}
svndiff plugins/zMobyPicturePlugin/lib/zMobyPictureClient.class.php
{% endhighlight %}


<div class="alert alert-warning" markdown="1">**Note**: You can achieve pretty much the same with vim. To learn about it read: "[Viewing svn diff result in vim](/viewing-svn-diff-result-in-vim)".</div>
