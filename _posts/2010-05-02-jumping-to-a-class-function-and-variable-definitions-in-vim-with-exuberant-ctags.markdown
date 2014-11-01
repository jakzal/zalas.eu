---
author: Jakub Zalas
comments: true
date: 2010-05-02 23:29:05
layout: post
slug: jumping-to-a-class-function-and-variable-definitions-in-vim-with-exuberant-ctags
title: Jumping to a class, function and variable definitions in vim with exuberant
  ctags
wordpress_id: 428
tags:
- ctags
- php
- vim
---

[Exuberant ctags](http://ctags.sourceforge.net/) make it possible to jump to the definition of a class, method, variable and any other language object in **vim**. Tool is  able to generate an index file (a.k.a tag file) for one of [41 supported programming languages](http://ctags.sourceforge.net/languages.html). Index can be used by     editors like vim to quickly find related keyword.


## Installation


Installation shouldn't be hard on any Linux based operating system. In Ubuntu **exuberant ctags** are in the default package repository. To install it you can use Ubuntu Software Center or open a terminal and write:

    
{% highlight bash %}
sudo aptitude install exuberant-ctags
{% endhighlight %}




## Generating an index file


Before taking advantage of **ctags** in **vim** you need to generate an index file. **ctags** command is made for that (it's an alias for ctags-exuberant).

To generate an index first change the working directory to the main directory of your project. After that tell ctags to recursively index the current directory:

    
{% highlight bash %}
cd ~/workspace/projects/sympal
ctags -R --languages=php .
{% endhighlight %}


<div class="alert alert-warning" markdown="1">
**Note**: Read '*man ctags*' for more options.
</div>

<div class="alert alert-warning" markdown="1">
**Note**: Long time ago [Matthew Weier O'Phinney](http://twitter.com/weierophinney) wrote a blog post about [exuberant ctags with PHP in vim](http://weierophinney.net/matthew/archives/134-exuberant-ctags-with-PHP-in-Vim.html). He used several options which look like no longer needed. I think ctags support for PHP has been improved over the time.
</div>


## Basic Usage


Basic usage boils down to the two commands:

* **ctrl-]** takes you to the declaration of a keyword your cursor is currently over. Jump is made so it doesn't matter in which file it is defined. Keyword is put on the tag stack.
* **ctrl-t** takes you a step back in the tag stack.


Notice that you can precede the command with a number to invoke it several times. It's useful when you have several definitions of the same tag and you don't want to jump to the first one      (**2ctrl-]**). From time to time you'll also need to jump back several tags (**4ctrl-t**).

You can make that vim directly opens a chosen keyword with **-t** option:

    
{% highlight bash %}
vim -t sfGuardUser
{% endhighlight %}




## Advanced Usage


Some of the **tag stack** commands:

* **pop** jumps backward in the tag stack
* **tag** jumps forward in the tag stack
* **tags** displays a tag stack


Some of the **tag match list** commands:

* **tselelect** lists the tags that match its argument or keyword under the cursor
* **g]** works like the **ctrl-]** but lets you to choose the tag occurrence
* **:tnext**, **:tprevious**, **:tfirst** and **:tlast** jump through the tag occurrences


Some of the **search** commands:

* **\[i** and **]i** display the first line containing the keyword under and after the cursor
* **\[I** and **]I** display all lines containing the keyword under and after the cursor
* **\[ ctrl-i** and **] ctr-i** jumps to the first line that contains the keyword under and after the cursor


<div class="alert alert-warning" markdown="1">
**Note**: Write **:help tags-and-searches** in vim to get total overview of features offered by tags.
</div>


## Useful links

* [Patching exuberant-ctags for better PHP5 support in vim](http://www.jejik.com/articles/2008/11/patching_exuberant-ctags_for_better_php5_support_in_vim/)
* [exuberant ctags with PHP in Vim](http://weierophinney.net/matthew/archives/134-exuberant-ctags-with-PHP-in-Vim.html)





## Video



<div class="text-center">
    <object width="480" height="385" data="http://www.youtube.com/v/8yjxaBrmiJI&amp;hl=en_US&amp;fs=1&amp;color1=0x3a3a3a&amp;color2=0x999999" type="application/x-shockwave-flash">
        <param name="allowFullScreen" value="true" />
        <param name="allowscriptaccess" value="always" />
        <param name="src" value="http://www.youtube.com/v/8yjxaBrmiJI&amp;hl=en_US&amp;fs=1&amp;color1=0x3a3a3a&amp;color2=0x999999" />
        <param name="allowfullscreen" value="true" />
    </object>
</div>

