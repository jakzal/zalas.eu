---
author: admin
comments: true
date: 2009-05-14 14:06:02
layout: post
slug: using-simplexml-with-sfwebbrowser-to-parse-html-documents
title: Using SimpleXML with sfWebBrowser to parse html documents
wordpress_id: 103
tags:
- parsers
- php
- sfWebBrowser
- SimpleXML
- symfony
---

[sfWebBrowser](http://www.symfony-project.org/plugins/sfWebBrowserPlugin) is a class that emulates web browser calls. It gives us nice object oriented interface to navigate through document structure in a programmed way. It can return response as [SimpleXML](http://pl2.php.net/simplexml) which enables us to use xpath queries on the document being parsed. We can easily get part of the page we need with a simple statement:

    
{% highlight php %}
$xml->xpath('//table[@class="main"]//tr[@class="odd" or @class="even"]');
{% endhighlight %}


Unfortunately html pages are hardly ever XML valid documents. That's why sfWebBrowser''s _getResponseXML()_ method rather throws an exception than returns SimpleXMLElement. Luckily there's a workaround for it. We can overwrite _getResponseXML_ method to create _SimpleXMLElement_ from _DOMDocument_ in case the original method fails.


{% highlight php %}
<?php

/*
 * (c) 2008 Jakub Zalas
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

/**
 * Web browser
 *
 * @package    zToolsPlugin
 * @subpackage lib
 * @author     Jakub Zalas <jakub@zalas.pl>
 * @version    SVN: $Id$
 */
class zWebBrowser extends sfWebBrowser
{
  /**
   * Returns response as XML
   *
   * If reponse is not a valid XML it is being created from
   * a DOM document which is being created from a text response
   * (this is the case for not valid HTML documents).
   *
   * @return SimpleXMLElement
   */
  public function getResponseXML()
  {
    try
    {
      $this->responseXml = parent::getResponseXML();
    }
    catch (Exception $exception)
    {
      $doc = new DOMDocument();
      $doc->loadHTML($this->getResponseText());
      $this->responseXml = simplexml_import_dom($doc);
    }

    return $this->responseXml;
  }
}
{% endhighlight %}
