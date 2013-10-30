---
author: Jakub Zalas
comments: true
date: 2009-08-03 15:47:41
layout: post
slug: how-to-use-textmate-like-snippets-in-vim
title: How to use TextMate like snippets in vim?
wordpress_id: 238
tags:
- best-practices
- productivity
- vim
---

Snippet is a piece of text which can be pasted into the document. Parts of it can be parametrized or calculated while pasting. Snippets can increase your productivity by letting you to write common chunks of code faster and without mistakes. One of the most famous snippet implementations is included in [TextMate editor](http://macromates.com/). In vim we have some of TextMate's snippet features bundled in [snipMate script](http://www.vim.org/scripts/script.php?script_id=2540).

<div class="text-center">
    <object width="425" height="344" data="http://www.youtube.com/v/gsMjQP4yxYw&amp;hl=pl&amp;fs=1&amp;" type="application/x-shockwave-flash">
        <param name="allowFullScreen" value="true" />
        <param name="allowscriptaccess" value="always" />
        <param name="src" value="http://www.youtube.com/v/gsMjQP4yxYw&amp;hl=pl&amp;fs=1&amp;" />
        <param name="allowfullscreen" value="true" />
    </object>
</div>


## Installation


Get snipMate from [vim website](http://www.vim.org/scripts/script.php?script_id=2540) and unpack it to your _~/.vim_ directory.


## How does it work?


Basically you need to write a keyword (called trigger) and press the `<TAB>` key to replace it with full snippet. For example typing '*for*' and pressing `<TAB>` while editing a PHP file:

    
    for<TAB>


expands to:

    
    for ($i=0; $i < count; $i++)
    {
    }


Pressing `<TAB>` key continuously moves you to the next defined tab stop. In this case you are able to adapt all expressions in 'for' loop and the last `<TAB>` moves you to the position inside it.


## Creating custom snippets


SnipMate comes with many predefined snippets but once you start using it, you need more. Fortunately it's easy to extend. Snippets are stored in _~/.vim/snippets_ directory. I started with reviewing the existing ones and adapted them to my coding standards. While doing this I got the idea about the snippets' structure and started with creating my own ones.

<div class="pull-right">
    <a href="/uploads/wp/2009/08/vim-html-snippets.png"><img src="/uploads/wp/2009/08/vim-html-snippets-400x172.png" alt="vim html snippets" title="vim html snippets" class="img-responsive" /></a>
</div>

Snippets are grouped by the file type. It is specified by a prefix in the snippet file name or a directory it was placed in (*php.snippets* vs *php/foreach.snippet*). The first version lets you to keep all file type related snippets in one place. The later is used to split your snippets into separate files. Format is slightly different between these two, so to make it simple I'll stick to the first one.

To define a new PHP snippet which expands 'get' keyword into a getter method put the code below into your _~/.vim/snippets/php.snippets_ file:

    
    snippet get
      $this->get${1}();${2}


**Note**: Snippets are indented with hard tabs. First tab is not expanded in the actual snippet.

Our snippet is run by '*get*' trigger and has two tab stops defined. Firstly cursor is placed after '$this->get' to let you fill the getter's name. Second tab moves the cursor after the completed statement.


## Tab stops and placeholders


Tab stop is a place where cursor goes next after pressing `<TAB>` key. The format is:

    
    ${1}


The number defines the order of navigation through the snippet.

**Note**: It's possible to go back to the previous position with `<Shift>+<TAB>`.

Tab stop can have a placeholder with default value:

    
    ${2:default}


Default value is pasted into the snippet. You can either change it or leave it by moving to the next position.

Placeholder's value can be copied throughout the snippet:

    
    Value of ${1:value} is copied here: $1 and here: $1 and snippet ends here: ${2}


All occurrences of  the _$1_ variable will be replaced by the provided value. It's also possible to use a variable in an another variable:

    
    <div id="${1:id}" name="${2:$1}">${3}</div>


Once you fill in the _id_ value, it is copied to the _name_ attribute. However, you can still change it if you want.


## Multiple matches


Sometimes its needed to have few versions of the snippet. Good example here is the PHP's foreach statement which I use at least in two variations:



	
* in regular PHP code:

  {% highlight php startinline %}
  foreach ($values as $key => $value)
  {
    // code here
  }
  {% endhighlight %}

* in templates:

  {% highlight php startinline %}
  <?php foreach ($values as $key => $value): ?>
    // code here
  <?php endforeach ?>
  {% endhighlight %}





Taking into account that _$key_ variable can be omitted, in fact I use four different variations of foreach statement. So I defined all four of them:

    
{% highlight php %}
snippet fore value
  foreach ($${1:variable} as $${2:value})
  {
    ${3}
  }

snippet fore key => value
  foreach ($${1:variable} as $${2:key} => $${3:value})
  {
    ${4}
  }

snippet fore value (template)
  <?php foreach ($${1:variable} as $${2:value}): ?>
    ${3}
  <?php endforeach ?>

snippet fore key => value (template)
  <?php foreach ($${1:variable} as $${2:key} => $${3:value}): ?>
    ${4}
  <?php endforeach ?>
{% endhighlight %}


Once I run 'fore' trigger vim lets me to choose which version of snippet I would like to use.

<div class="text-center">
    <a href="/uploads/wp/2009/08/vim-multisnippet.png"><img src="/uploads/wp/2009/08/vim-multisnippet-400x176.png" alt="vim multi choice snippet" title="vim multi choice snippet" class="img-responsive" /></a>
</div>






## Learn it


There are some things about snipMate I didn't mention. For more knowledge visit its [homepage](http://www.vim.org/scripts/script.php?script_id=2540) and read the documentation in _~/.vim/doc/snipMate.txt_. There are also many snippets available on the Internet which are a good reference.


## Make it your habit


Making usage of snippets a habit for sure will boost your productivity. To take full advantage of it you need to extend your snippet library. I think it's best to create a new snippet once you feel one is missing and directly start using it. Waiting till "next time" lasts through the eternity.
