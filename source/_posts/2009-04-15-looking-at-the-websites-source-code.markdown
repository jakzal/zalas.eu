---
author: Jakub Zalas
comments: true
date: 2009-04-15 13:47:59
layout: post
slug: looking-at-the-websites-source-code
title: Looking at the website's source code
wordpress_id: 3
tags:
- cache
- filter
- html
- symfony
---

Most of the web programmers have some kind of deviation that tells them to look
into the source code of the websites they visit. In many cases author planned to
have nice indented output. In other cases author just didn't care.

Usually templates are designed to produce output like:

```html
<html>
  <head>
    <title>My great website</title>
  </head>
  <body>
    <div>
      <h1>Hello!</h1>
    </div>
  </body>
</html>
```

but most often what's generated looks more like:

```html
<html>  <head>
            <title>My great website</title>  </head>
    <body>
 <div>
      <h1>Hello!</h1>    </div>  </body>
             </html>
```

Tools like Opera's [Dragonfly](http://www.opera.com/dragonfly/) or
[Firebug](http://getfirebug.com/) for Firefox can help us to view the source in
nice way. Html indentation matters only in the templates so designers and
programmers can read it easily while developments. For browser or crawler it
doesn't matter. Everything could be placed in one long line of code. Whitespace
characters are just empty data which needs to go between the server and user's
browser. The bigger is the website the more whitespace characters needs to be
transfered and it's not even displayed. Maybe it's not such a big deal one could
say. But it's also not such a big job to remove it...

```html
<html><head><title>My great website</title></head><body><div><h1>Hello!</h1></div></body></html>
```

Symfony processes request in a
[filter chain](http://www.symfony-project.org/book/1_2/06-Inside-the-Controller-Layer#chapter_06_filters).
I will show how to write a filter which removes all the whitespace characters
(omitting pre-formated text of course).
I called the class *zContentCleanerFilter*.

Let's start with main filter method - *execute()*. In this method first we'll
execute next filter in the chain to let all the content be generated. If it's
the first call of the filter and cleaning is turned on
(*app_content_cleaner_enabled* configuration option is set to true) we invoke
the cleaning method on the content (*zContentCleanerFilter::cleanContent()*)
and overwrite it in the response object.

```php
class zContentCleanerFilter extends sfFilter
{
  public function execute($filterChain)
  {
    $filterChain->execute();

    if ($this->isFirstCall() && sfConfig::get('app_content_cleaner_enabled', false))
    {
      $response = $this->getContext()->getResponse();
      $content  = $response->getContent();
      $content  = self::cleanContent($content);

      $response->setContent($content);
    }
  }
}
```

*zContentCleanerFilter::cleanContent()* method uses callback function to
process content line by line.

    
```php
  public static function cleanContent($content)
  {
    return preg_replace_callback(
      '/^((\s*)(.*?)(\s*)(\r\n|\r|\n)|(\s*))/smi',
      array('zContentCleanerFilter', 'cleanLine'),
      $content
    );
  }
```

We have to check each line for preformatted text. If part of html code is
inside `<pre>` tag than *zContentCleanerFilter::cleanLine()* returns
it as is.

```php
  private static function cleanLine($matches)
  {
    static $preCount = 0;

    $line = $matches[0];

    $startPreCount = substr_count($line, '<pre');
    $endPreCount   = substr_count($line, '</pre>');

    $preCount+= $startPreCount;
    $preCount-= $endPreCount;

    if ($preCount !== 0)
    {
      if (false !== strpos($line, '<pre') && $startPreCount !== $endPreCount)
      {
        // Preformatted code is starting, remove only white-spaces from the beginning
        $line = ltrim($line);
      }
    }
    elseif (false !== strpos($line, '</pre') && $startPreCount !== $endPreCount)
    {
      // Preformatted code is ending, remove only trailing white-spaces
      $line = rtrim($line);
    }
    else
    {
      $line = trim($line);
    }

    return $line;
  }
```

That's all. To use the filter in a project we have to configure it to be run in
the filter chain. I've added it into application's <em>factories.yml</em> file
after the cache filter.

```yaml
rendering: ~
security:  ~
cache:     ~

# it's here to cache result when page is cached with layout
contentCleaner:
  class: zContentCleanerFilter

common: ~
execution: ~
```

Running content cleaning filter after cache filter takes advantage of caching
the result of cleaning (which could be taken as not efficient). Cache filter is
invoked sooner and skips filters which should be run afterwards.
