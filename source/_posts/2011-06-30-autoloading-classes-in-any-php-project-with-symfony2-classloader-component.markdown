---
author: Jakub Zalas
comments: true
date: 2011-06-30 11:33:37
layout: post
slug: autoloading-classes-in-any-php-project-with-symfony2-classloader-component
title: Autoloading classes in an any PHP project with Symfony2 ClassLoader component
wordpress_id: 768
tags:
- autoloader
- ClassLoader
- components
- php
- Symfony2
meta_keywords: Symfony,components,autoloader,classloader
meta_description: Symfony's ClassLoader component is a PSR-0 standard compliant PHP class autoloader. 
---

Symfony [ClassLoader component](https://github.com/symfony/ClassLoader) is a [PSR-0 standard](http://groups.google.com/group/php-standards/web/psr-0-final-proposal) compliant PHP class autoloader. It's not only able to load namespaced code but also supports old-school [PEAR standards](http://pear.php.net/manual/en/standards.naming.php) (also used by Zend Framework). It's a perfect class loading tool for most of PHP projects.

<div class="alert alert-warning" markdown="1">
**Note**: Code used in this post is available on github: [https://github.com/jakzal/SymfonyComponentsExamples](https://github.com/jakzal/SymfonyComponentsExamples)
</div>


## Installation


You can either install it from the [Symfony PEAR channel](http://pear.symfony.com/) or grab it [directly from github](https://github.com/symfony/ClassLoader). For the purpose of this article we'll clone the sources to the _vendor/_ directory of the project.

<div class="alert alert-warning" markdown="1">
**Note**: ClassLoader component uses _Symfony\Component\ClassLoader_ namespace. Therefore we'll put it into _Symfony/Component/ClassLoader_ subdirectory of _vendor_ (see [PSR-0 standard](http://groups.google.com/group/php-standards/web/psr-0-final-proposal)).
</div>

    
```bash
git clone https://github.com/symfony/ClassLoader.git vendor/Symfony/Component/ClassLoader
```




## Basic Usage


Let's say we have two Acme libraries.

First one is located in the  _src/Acme/Tools_. _HelloWorld_ class uses _Acme\Tools _namespace and is declared in the _src/Acme/Tools/HelloWorld.php_ file:

    
```php
<?php
// src/Acme/Tools/HelloWorld.php

namespace Acme\Tools;

class HelloWorld
{
    public function __construct()
    {
        echo __METHOD__."\n";
    }
}
```


Second library is stored in the _src/Legacy/Acme/Tools_. It follows old but well known PEAR naming standards. *Legacy_Acme_Tools_HelloWorld* class is defined in the _src/Legacy/Acme/Tools/HelloWorld.php_ file:

    
```php
<?php
// src/Legacy/Acme/Tools/HelloWorld.php

class Legacy_Acme_Tools_HelloWorld
{
    public function __construct()
    {
        echo __METHOD__."\n";
    }
}
```


To make that our classes are automatically loaded we have to register _Acme_ namespace and _Legacy__ prefix:

    
```php
<?php
// classloader.php

require_once __DIR__.'/vendor/Symfony/Component/ClassLoader/UniversalClassLoader.php';
$loader = new Symfony\Component\ClassLoader\UniversalClassLoader();
$loader->registerNamespaces(array('Acme' => __DIR__ . '/src'));
$loader->registerPrefixes(array('Legacy_' => __DIR__ . '/src'));
$loader->register();

$helloWorld = new Acme\Tools\HelloWorld();
$legacyHelloWorld = new Legacy_Acme_Tools_HelloWorld();
```


Of course classes are only loaded when needed. Requiring _UniversalClassLoader.php_ file should be the only _require_ statement used in our code. Other classes should be loaded by the class loader.

<div class="alert alert-warning" markdown="1">
**Note**: There's also a way to define paths with _registerNamespaceFallbacks()_ and _registerPrefixFallbacks()_. Class loader will use them with namespaces or prefixes which weren't listed explicitly.
</div>


## Increasing performance


Number of class files in a real-world project is rather big. Class loader might have some impact on performance as it checks for file existence before requiring it. To avoid disk operations we can cache results in APC with _ApcUniversalClassLoader_:

    
```php
<?php
// classloadercached.php

require_once __DIR__.'/vendor/Symfony/Component/ClassLoader/UniversalClassLoader.php';
require_once __DIR__.'/vendor/Symfony/Component/ClassLoader/ApcUniversalClassLoader.php';

$loader = new Symfony\Component\ClassLoader\ApcUniversalClassLoader('ClassLoader');
$loader->registerNamespaces(array('Acme' => __DIR__ . '/src'));
$loader->registerPrefixes(array('Legacy_' => __DIR__ . '/src'));
$loader->register();

$helloWorld = new Acme\Tools\HelloWorld();
$legacyHelloWorld = new Legacy_Acme_Tools_HelloWorld();
```


<div class="alert alert-warning" markdown="1">
**Note**: Examples are run in a command line. Therefore there's no performance gain from using APC. In fact it can hurt performance as cache is initialized every time our script is run in cli. This is a limitation of APC.
</div>
