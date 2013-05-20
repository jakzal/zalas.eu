---
author: admin
comments: true
date: 2010-05-01 21:24:28
layout: post
slug: exploring-files-and-directories-in-vim-with-the-nerd-tree-plugin
title: Exploring files and directories in vim with the NERD tree plugin
wordpress_id: 412
tags:
- nerdtree
- plugin
- vim
---

Exploring, opening, switching, renaming, moving files and directories are common tasks performed during coding. In IDEs it is usually achieved with some kind of filesystem explorer. In vim I preffer to use the [NERD tree plugin](http://www.vim.org/scripts/script.php?script_id=1658).

[![NERD tree plugin for vim](/uploads/wp/2010/05/nerdtree-400x275.png)](/uploads/wp/2010/05/nerdtree.png)


## NERD Tree features


**NERD tree** enables you to:



	
  * **Navigate** and **jump** through the directory tree

	
  * **Open** files in the current window, tab, split view (horizontal and vertical)

	
  * **Change** the current working directory

	
  * **Add**, **move**, **copy** and **remove** files and directories

	
  * **Filter** the tree

	
  * **Create the bookmarks**




## Installation


Get the source from [the plugin website](http://www.vim.org/scripts/script.php?script_id=1658) and unzip it into your _~/.vim_ directory.

To make   using **NERD tree** more convenient it's best to create a shortcut mapping. To use ctrl+n add the following line to your _~/.vimrc_ file:

    
    nmap <silent> <c-n> :NERDTreeToggle<CR>




## Usage


Run vim and type _:NERDTreeToggle_ or _ctrl+n_. The later will work only if you've created a   mapping. **NERD tree** should open and present you the directory structure.

I'd suggest you to start with pressing the _?_ to read a quick help and learn about the plugin features.




