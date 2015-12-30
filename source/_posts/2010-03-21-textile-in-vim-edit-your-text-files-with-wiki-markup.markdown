---
author: Jakub Zalas
comments: true
date: 2010-03-21 23:09:24
layout: post
slug: textile-in-vim-edit-your-text-files-with-wiki-markup
title: Textile in vim - edit your text files with wiki markup
wordpress_id: 361
tags:
- plugin
- textile
- vim
expired: true
---

[Textile](http://en.wikipedia.org/wiki/Textile_%28markup_language%29) is a simple markup language. It's used in CMS and wiki implementations (i.e. Redmine). I also like to use it while making notes in a plain text files.

[Textile plugin for vim](http://www.vim.org/scripts/script.php?script_id=2305) adds support for syntax highlighting, preview and html conversion of Textile documents.

<div class="text-center">
    <a href="/uploads/wp/2010/03/vim-textile.png"><img src="/uploads/wp/2010/03/vim-textile-400x375.png" title="Textile plugin in vim" alt="Textile plugin in vim" class="img-responsive" /></a>
</div>


## Requirements


If you plan to use preview or html conversion you'll need ruby:

    
    sudo aptitude install ruby libredcloth-ruby


In case you only need syntax highlighting you can skip it.


## The plugin


Get the source and unpack it to your _~/.vim_ directory. Detailed installation instructions are available on [the plugin page](http://www.vim.org/scripts/script.php?script_id=2305).

I prefer to use textile with txt files. To tell vim that it should treat txt files as Textile add the following line to your _~/.vim/ftdetect/txt.vim_:

    
```vim
au BufRead,BufNewFile *.txt     set filetype=textile
```
