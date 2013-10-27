---
author: Jakub Zalas
comments: true
date: 2009-08-01 02:26:48
layout: post
slug: how-to-record-a-macro-in-vim
title: How to record a macro in vim?
wordpress_id: 200
tags:
- best-practices
- productivity
- vim
---

[Macro](http://en.wikipedia.org/wiki/Macro_%28computer_science%29) is a sequence of instructions performed as a one step. In programming it helps automating the repeatable tasks which makes them less boring and less error-prone. Instead of performing the same actions over and over again, it's better to record them as a macro. Once macro is saved it can be run as many times as needed. [Vim](http://www.vim.org/) as a one of most powerful editors has macro support built in.

<div class="text-center">
    <object width="425" height="344" data="http://www.youtube.com/v/6d4tZqqQm6s&amp;hl=en&amp;fs=1" type="application/x-shockwave-flash">
        <param name="allowFullScreen" value="true" />
        <param name="allowscriptaccess" value="always" />
        <param name="src" value="http://www.youtube.com/v/6d4tZqqQm6s&amp;hl=en&amp;fs=1" />
        <param name="allowfullscreen" value="true" />
    </object>
</div>

To record a macro in vim you need to:

* start macro recording: _qa_
* perform chain of repeatable actions: _(regular vim commands)_
* stop recording process: _q_





## Defining the automation


First, it's good to think what actually should be recorded. For purpose of this example let's say you have a file with a list of songs and artists you want to put on your website. Each row should be shown as a separate list item and song title has to be formatted as an italic text. The file contents is as below:

    
    "All Along the Watchtower", Jimi Hendrix
    "Smells Like Teen Spirit", Nirvana
    "Oops!... I did it again", Britney Spears
    "A Hard Day's Night", The Beatles
    "One", Metallica
    "Lasy Pomorza", Behemoth


To format first line of file in vim you could perform the following commands:

* Go to the beginning of line by pressing _^_

  ```"All Along the Watchtower", Jimi Hendrix```

* Turn on insert mode (*i*), add two spaces and opening html tags: `<li><i>`

  ```<li><i>"All Along the Watchtower", Jimi Hendrix```

* Exit insert mode (*ESC*), move the cursor to the next comma location: _f,_

* Turn on insert mode (*i*) and add italics ending tag: `</i>`

  ```<li><i>"All Along the Watchtower"</i>, Jimi Hendrix```

* Exit insert mode (*ESC*), go to the end of line in insert mode (*A*) and add list closing tag `</li>`

  ```<li><i>"All Along the Watchtower"</i>, Jimi Hendrix</li>```

* Leave insert mode (*ESC*) and go to the next line


The rest of lines can be formatted the same way. As you can see it could be quite a big and tedious job, especially with a large file. It's better when computer does it for us.


## Entering the macro recording process


To start macro recording process press


    qa


in normal mode. '*a*' is a register where your macro will be saved. You can choose any letter you want.


## Recording the macro


Now, perform the steps explained before to format the first line. It's only needed to do it once. It's important that we end up in a state that allows us running next iteration.


## Saving the macro


To save the macro press


    q


This will exit macro recording process.


## Running the macro


While recording the macro we have formatted the first line. Assuming that macro was saved in 'a' register we can process next line by pressing:


    @a


To proceed with remaining four lines of file it's possible to specify number of times macro has to be run:


    4@a


Result will look like following:


      <li><i>"All Along the Watchtower"</i>, Jimi Hendrix</li>
      <li><i>"Smells Like Teen Spirit"</i>, Nirvana</li>
      <li><i>"Oops!... I did it again"</i>, Britney Spears</li>
      <li><i>"A Hard Day's Night"</i>, The Beatles</li>
      <li><i>"One"</i>, Metallica</li>
      <li><i>"Lasy Pomorza"</i>, Behemoth</li>




## Summary


Programmer's job is to write programs. By performing repeatable tasks manually we are doing a bad job, because it's a computer's job. Such actions make us numb as there's not much thinking involved. Furthermore we make mistakes and computer repeats the operations with a deadly precision. Incorporating macros in your development skill set will improve your productivity.

If you don't use vim there are macro recorders for most of popular IDEs available. If your editor doesn't support it than still it's possible to use standalone desktop applications which can be easily integrated with tools of your preference.

Other way of performing similar tasks in vim is using regular expressions but it's a subject for another post.

