---
author: Jakub Zalas
comments: true
date: 2011-09-06 07:58:30
layout: post
slug: managing-object-creation-in-php-with-the-symfony2-dependency-injection-component
title: Managing object creation in PHP with the Symfony2 Dependency Injection component
wordpress_id: 832
tags:
- components
- DependencyInjection
- DIC
- php
- Symfony2
---

Symfony's [DependencyInjection component](https://github.com/symfony/DependencyInjection) is a PHP implementation of a **Service Container**, or as others like to call it, a **Dependency Injection Container** (DIC).

The component also provides useful tools for handling service definitions, like XML loaders or dumpers.


<div class="text-center">
    <img src="/uploads/wp/2011/09/injection.png" title="Injection - image credits: http://www.flickr.com/photos/alexnormand/3132689510/" alt="Injection - image credits: http://www.flickr.com/photos/alexnormand/3132689510/" class="img-responsive" />
</div>


If you want to learn more about the dependency injection or the dependency injection container, read an excellent series of articles on the subject by Fabien Potencier: [What is Dependency Injection?](http://fabien.potencier.org/article/11/what-is-dependency-injection)

<div class="alert alert-warning" markdown="1">
**Note**: Code used in this post is available on github: [https://github.com/jakzal/SymfonyComponentsExamples](https://github.com/jakzal/SymfonyComponentsExamples)
</div>


## Installation


Use the [Symfony PEAR channel](http://pear.symfony.com/) or grab the source code [directly from github](https://github.com/symfony/Finder). For the purpose of this article we'll clone the component to the _vendor/_ directory of the project.

We will also need Buzz, a lightweight HTTP client. It'll serve us as an example service. [Config](https://github.com/symfony/Config/) component is needed for one of the code snippets.

    
{% highlight bash %}
git clone https://github.com/symfony/DependencyInjection.git vendor/Symfony/Component/DependencyInjection
git clone https://github.com/symfony/Config.git vendor/Symfony/Component/Config
git clone https://github.com/symfony/ClassLoader.git vendor/Symfony/Component/ClassLoader
git clone https://github.com/kriswallsmith/Buzz.git vendor/Buzz
{% endhighlight %}


Symfony _ClassLoader_ component will take care of the class autoloading (*read more about it in the* "[Autoloading classes in an any PHP project with Symfony2 ClassLoader component](http://zalas.eu/autoloading-classes-in-any-php-project-with-symfony2-classloader-component/)").

Following code is sufficient to load classes from an any Symfony component (assuming components are put into the _vendor/Symfony/Component_ directory):

    
{% highlight php %}
<?php
// src/autoload.php
require_once __DIR__.'/../vendor/Symfony/Component/ClassLoader/UniversalClassLoader.php';

$loader = new Symfony\Component\ClassLoader\UniversalClassLoader();
$loader->registerNamespaces(array(
    'Symfony' => __DIR__.'/../vendor',
    'Buzz'    => __DIR__.'/../vendor/Buzz/lib',
    'PSS'     => __DIR__
));
$loader->register();
{% endhighlight %}




## Creating objects, the usual way


To create a _Browser_ object and fetch content from google we could write the following piece of code:


{% highlight php startinline %}
$browser = new \Buzz\Browser();
$response = $browser->get('http://www.google.com');
{% endhighlight %}


By default **Buzz** uses _FileGetContents_ as a client (which is a wrapper for *file_get_contents()* PHP function). Imagine new requirements came and forced us to use curl.

It's possible with Buzz. We just need to pass the client explicitly to the Browser:

    
{% highlight php startinline %}
$client = new \Buzz\Client\Curl();
$browser = new \Buzz\Browser($client);
$response = $browser->get('http://www.google.com');
{% endhighlight %}


After a while we noticed that our calls are often timed out. Default timeout of 5 seemed to be not sufficient so we increased it to 15:

    
{% highlight php startinline %}
$client = new \Buzz\Client\Curl();
$client->setTimeout(15);
$browser = new \Buzz\Browser($client);
$response = $browser->get('http://www.google.com');
{% endhighlight %}


Notice that code needs to be modified in all the places the _Browser_ was used. It soon becomes a maintenance hell. Copy&Paste is not the best way for re-usability ;) Just imagine effort needed to change the connection timeout when you create the browser in ten places. Or changing the client. What if you forget one?

We might create factory for the Browser. However, writing factories for all our services breaks [DRY principle](http://en.wikipedia.org/wiki/Don't_repeat_yourself) as we end up writing classes with a similar purpose.

One of the solutions is to **centralize the object creation**. Dependency Injection Container (DIC) does just that.

<div class="alert alert-warning" markdown="1">
**Note**: Dependency Injection Container is also called a **Service Container**. Thinking about objects managed by the container as services, better reflects the purpose of the container.
</div>


## Creating objects with DIC


Instead of creating Browser object explicitly, we'll just **tell the container how to do it**:

    
{% highlight php %}
<?php
// dependencyinjection.php

require_once __DIR__.'/src/autoload.php';

use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\DependencyInjection\Definition;

$serviceContainer = new ContainerBuilder();

$browserDefinition = new Definition('Buzz\Browser');
$serviceContainer->setDefinition('browser', $browserDefinition);
{% endhighlight %}


And then **ask it for the service**:


{% highlight php startinline %}
$browser = $serviceContainer->get('browser');
$response = $browser->get('http://www.google.com/');
{% endhighlight %}


To replace the default HTTP client with Curl we might define another service and pass it to the browser as a reference:

    
{% highlight php %}
<?php
// dependencyinjection.php

// ...

$serviceContainer = new ContainerBuilder();

$clientDefinition = new Definition('Buzz\Client\Curl');
$clientDefinition->addMethodCall('setTimeout', array(15));
$serviceContainer->setDefinition('browser.client', $clientDefinition);

$browserDefinition = new Definition('Buzz\Browser', array(new Reference('browser.client')));
$serviceContainer->setDefinition('browser', $browserDefinition);
{% endhighlight %}


Notice that even though object creation becomes more and more complicated we **manage it in one place**.

On the other hand, every time we want to use a browser all we need to do is to get it from the container:

    
{% highlight php startinline %}
$browser = $serviceContainer->get('browser');
{% endhighlight %}


**Service consumers are not affected by the service definition changes.**

Another nice thing is that service won't be created unless we requested it.


## Using XML to describe services


Services can be defined in many formats, not just PHP. **Yaml** and **XML** seem to be most convinient and readable ones. Symfony DependencyInjection component gives us tools to dump and load service definitions into the container with _ContainerBuilder_.

Moving service definitions to the configuration stored in Yaml or XML files has several advantages.

First of all we're creating even **clearer separation** between an object creation and the code which uses it.

Secondly, service definitions are more **readable**.

Following XML file describes the same services we defined in PHP before:

    
{% highlight xml %}
<?xml version="1.0" encoding="utf-8"?>
<-- config/buzz.xml -->
<container xmlns="http://symfony.com/schema/dic/services"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="http://symfony.com/schema/dic/services http://symfony.com/schema/dic/services/services-1.0.xsd">
  <services>
    <service id="browser.client" class="Buzz\Client\Curl">
      <call method="setTimeout">
        <argument>15</argument>
      </call>
    </service>
    <service id="browser" class="Buzz\Browser">
      <argument type="service" id="browser.client"/>
    </service>
  </services>
</container>
{% endhighlight %}


Loading the service definitions into the container is fairly simple. We need to create a _CotnainerBuilder_ and pass it to an _XmlFileLoader_ which will do all the work for us:

    
{% highlight php %}
<?php
// dependencyinjectionloader.php

require_once __DIR__.'/src/autoload.php';

use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\DependencyInjection\Loader\XmlFileLoader;
use Symfony\Component\Config\FileLocator;

/**
 * Loading services
 */

$serviceContainer = new ContainerBuilder();
$loader = new XmlFileLoader($serviceContainer, new FileLocator(__DIR__.'/config'));
$loader->load('buzz.xml');

/**
 * Using services
 */

$browser = $serviceContainer->get('browser');
$response = $browser->get('http://www.google.com/');
{% endhighlight %}


The opposite works equally well. To dump service definitions into an _XML_ we need to pass _ContainerBuilder_ instance to the _XmlDumper_:

    
{% highlight php %}
<?php
// dependencyinjection.php

// ...

use Symfony\Component\DependencyInjection\Dumper\XmlDumper;

$dumper = new XmlDumper($serviceContainer);
echo $dumper->dump();
{% endhighlight %}


<div class="alert alert-warning" markdown="1">
**Note**: In a real life scenario we'd probably maintain our service definitions in XML or YML file(s) but dump them to PHP with _PhpDumper_ for **performance** reasons.
</div>


## Visualizing the services


In complex application services and relations between them might become, well... complex. GraphvizDumper might be handy in such situations as it lets us to present the services on a graph.

    
{% highlight php %}
<?php
// dependencyinjectiongraphviz.php

require_once __DIR__.'/src/autoload.php';

use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\DependencyInjection\Dumper\GraphvizDumper;
use Symfony\Component\DependencyInjection\Loader\XmlFileLoader;
use Symfony\Component\Config\FileLocator;

$serviceContainer = new ContainerBuilder();
$loader = new XmlFileLoader($serviceContainer, new FileLocator(__DIR__.'/config'));
$loader->load('buzz.xml');

$dumper = new GraphvizDumper($serviceContainer);
echo $dumper->dump();
{% endhighlight %}


To actually generate a graph we will need a dot program (from graphviz). Once we dump the result of our script into a _services.dot_ file we can easily convert it to an image:

    
{% highlight bash %}
dot -Tpng -o services.png services.dot
{% endhighlight %}


The result should look similar to the following picture.

<div class="text-center">
    <a href="/uploads/wp/2011/08/services.png"><img src="/uploads/wp/2011/08/services-400x112.png" title="Symfony DIC services graph" alt="Symfony DIC services graph" class="img-responsive" /></a>
</div>


