---
author: admin
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


[![svn diff in black and white](/uploads/wp/2009/06/svn-diff-before-399x183.png)](/uploads/wp/2009/06/svn-diff-before.png)



We can improve our experience a bit by installing [colordiff](http://colordiff.sourceforge.net/). It wraps _diff_ command and produces the same output but coloured.


[![svn diff in colors](/uploads/wp/2009/06/svn-diff-after-400x183.png)](/uploads/wp/2009/06/svn-diff-after.png)



In ubuntu it's as simple as running:

    
    sudo aptitude install colordiff


Once doing that we should be able to redirect the output of commands like _diff_ and _svn diff_ to colordiff and view it in colors:

    
    svn diff plugins/zMobyPicturePlugin/lib/zMobyPictureClient.class.php | colordiff


To improve it even more we can declare simple function in _~/.bashrc_ file (using it requires re-login):

    
    svndiff()
    {
      svn diff "${@}" | colordiff
    }


Function will make the command shorter:

    
    svndiff plugins/zMobyPicturePlugin/lib/zMobyPictureClient.class.php


**Note**: You can achieve pretty much the same with vim. To learn about it read: "[Viewing svn diff result in vim](/viewing-svn-diff-result-in-vim)".
