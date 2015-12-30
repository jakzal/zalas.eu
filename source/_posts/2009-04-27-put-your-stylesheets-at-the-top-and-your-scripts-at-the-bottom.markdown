---
author: Jakub Zalas
comments: true
date: 2009-04-27 15:33:16
layout: post
slug: put-your-stylesheets-at-the-top-and-your-scripts-at-the-bottom
title: Put your stylesheets at the top and your scripts at the bottom
wordpress_id: 36
tags:
- best-practices
- filter
- html
- symfony
expired: true
---

Putting the CSS stylesheets at the top of your web page and moving the scripts
to the bottom are only two of thirty four rules described in
[Best Practices for Speeding Up Your Website](http://developer.yahoo.com/performance/rules.html)
(by Yahoo).
Following these two rules, however, can really decrease visible time of page
rendering. I will present a simple solution to achieve this in
[symfony](http://www.symfony-project.org/) framework.

Whenever you invoke *use_javascript* and *use_stylesheet* helpers your
JavaScripts and stylesheets are not directly put into the content. This task is
given to *sfCommonFilter* which is responsible for injecting JavaScript and
stylesheet includes right before *</head>* tag. Thanks to that we can safely
request inclusion of the same file multiple of times and it's pasted into the
content only once. It's nice but can be slightly improved by following the
earlier mentioned Yahoo rules.

Stylesheets are already at the top. The only thing left is to move JavaScripts
right before the *</body>* tag.  To do that we will have to overwrite the
*sfCommonFilter* class. Thankfully it's just a matter of small changes in the
original class. I used the original code and changed the way the scripts are
injected.

```php
class zCommonFilter extends sfFilter
{
  public function execute($filterChain)
  {
    $filterChain->execute();

    $response = $this->context->getResponse();

    // include stylesheets
    $content = $response->getContent();
    if (false !== ($pos = strpos($content, '</head>')))
    {
      $this->context->getConfiguration()->loadHelpers(array('Tag', 'Asset'));
      $html = '';
      if (!sfConfig::get('symfony.asset.stylesheets_included', false))
      {
        $html.= get_stylesheets($response);

        if ($html)
        {
          $response->setContent(substr($content, 0, $pos) . $html . substr($content, $pos));
        }
      }
    }

    // include javascripts
    $content = $response->getContent();
    if (false !== ($pos = strpos($content, '</body>')))
    {
      $this->context->getConfiguration()->loadHelpers(array('Tag', 'Asset'));
      $html = '';
      if (!sfConfig::get('symfony.asset.javascripts_included', false))
      {
        $html.= get_javascripts($response);

        if ($html)
        {
          $response->setContent(substr($content, 0, $pos) . $html . substr($content, $pos));
        }
      }
    }

    sfConfig::set('symfony.asset.javascripts_included', false);
    sfConfig::set('symfony.asset.stylesheets_included', false);
  }
}
```

Now we just need to tell symfony to use our version of the common filter instead
of the default one. As always we do it in _filters.yml_ file of chosen
application:

```yaml
rendering: ~
security:  ~
cache:     ~

common:
  class: zCommonFilter

execution: ~
```
