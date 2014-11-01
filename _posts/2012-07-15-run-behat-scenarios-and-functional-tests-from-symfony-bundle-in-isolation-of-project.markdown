---
author: Jakub Zalas
comments: true
date: 2012-07-15 14:47:49
layout: post
slug: run-behat-scenarios-and-functional-tests-from-symfony-bundle-in-isolation-of-project
title: How to run Behat scenarios and functional tests from a Symfony bundle in isolation of a project?
wordpress_id: 937
tags:
- behat
- bundle
- Symfony2
- testing
- travis
---

When working on a reusable bundle it's beneficial to run its test suite in isolation of a project. This way test suite is not dependent on project's configuration or enabled bundles. It is also much easier to run it on a continuos integration server like [Travis](http://travis-ci.org/).


## AppKernel and configuration


Providing an _AppKernel_ is the main task we need to do to run both Behat scenarios and functional tests from our bundle without installing it in a Symfony2 project.

Within an _AppKernel_ we're able to register bundles and container configuration (*registerBundles()* *registerContainerConfiguration()* methods). Next to the bundle we're working on, we should enable and configure bundles required for it to work.

Configuration is typically done in _[config/config_test.yml](https://github.com/jakzal/DemoBundle/blob/master/Features/Fixtures/Project/app/config/config_test.yml)_ file (scenarios and tests are usually run in a test environment). Most of the time we'll also need a routing file (typically _[config/routing_test.yml](https://github.com/jakzal/DemoBundle/blob/master/Features/Fixtures/Project/app/config/routing_test.yml)_).

Last but not least it's good to change the default location of cache and logs to a temporary directory (*getCacheDir()* and *getLogDir()* methods).

    
{% highlight php %}
<?php

use Symfony\Component\HttpKernel\Kernel;
use Symfony\Component\Config\Loader\LoaderInterface;

class AppKernel extends Kernel
{
    /**
     * @return array
     */
    public function registerBundles()
    {
        return array(
            new Symfony\Bundle\FrameworkBundle\FrameworkBundle(),
            new Symfony\Bundle\TwigBundle\TwigBundle(),
            new Symfony\Bundle\MonologBundle\MonologBundle(),
            new Sensio\Bundle\FrameworkExtraBundle\SensioFrameworkExtraBundle(),
            new Zalas\Bundle\DemoBundle\ZalasDemoBundle()
        );
    }

    /**
     * @return null
     */
    public function registerContainerConfiguration(LoaderInterface $loader)
    {
        $loader->load(__DIR__.'/config/config_'.$this->getEnvironment().'.yml');
    }

    /**
     * @return string
     */
    public function getCacheDir()
    {
        return sys_get_temp_dir().'/ZalasDemoBundle/cache';
    }

    /**
     * @return string
     */
    public function getLogDir()
    {
        return sys_get_temp_dir().'/ZalasDemoBundle/logs';
    }
}
{% endhighlight %}


I usually put the kernel in _Features/Fixtures/Project/app/AppKernel.php_ (for Behat) or _Tests/Functional/app/AppKernel.php_ (for functional tests) but the location doesn't matter.

For more flexibility look at the [FrameworkBundle](https://github.com/symfony/symfony/tree/master/src/Symfony/Bundle/FrameworkBundle/Tests/Functional/app) or [JMSPaymentCoreBundle](https://github.com/schmittjoh/JMSPaymentCoreBundle/tree/master/Tests/Functional). Both bundles have good examples of parametrized kernel configurations.


## Autoloader


Using [composer](http://getcomposer.org/) solves most of our autoloading problems. We only need to remember of setting _target-dir_ in our _composer.json_ (big thanks to [Adrien Brault](https://twitter.com/AdrienBrault) for pointing it out):

    
{% highlight json %}
{
    "autoload": {
        "psr-4": { "Zalas\\Bundle\\DemoBundle\\": "" }
    }
}
{% endhighlight %}


We'll also need to register an autoloader for annotations (if we use annotations).

Following example of _bootstrap.php_ is a simple implementation of an autoloader for functional tests. To use it with Behat path to the _vendor/autoload.php_ needs to be updated.

    
{% highlight php startinline %}
<?php

use Doctrine\Common\Annotations\AnnotationRegistry;

if (!file_exists($file = __DIR__.'/../vendor/autoload.php')) {
    throw new \RuntimeException('Install the dependencies to run the test suite.');
}

$loader = require $file;
AnnotationRegistry::registerLoader(array($loader, 'loadClass'));
{% endhighlight %}




## Behat




<div class="text-center">
    <img src="/uploads/wp/2012/07/scenarios.png" title="Behat features folder" alt="Behat features folder" class="img-responsive" />
</div>

Once we prepared the _AppKernel_ and set up the autoloading we can move to Behat configuration. In particular, we need to define:
* path to the Features folder
* list of contexts we need to use
* path to the *AppKernel* (*kernel.path* for the Symfony2 extension)
* path to the bootstrap file for the Symfony2 extension (*kernel.bootsrap* for the Symfony2 extension)



    
{% highlight yaml %}
default:
  suites:
    demo:
      formatter:
        name: progress
      paths:
        features: Features
      contexts: [Zalas\Bundle\DemoBundle\Features\Context\FeatureContext]
  extensions:
    Behat\Symfony2Extension:
      kernel:
        env: test
        debug: true
        path: Features/Fixtures/Project/app/AppKernel.php
        bootstrap: Features/Fixtures/Project/app/bootstrap.php
    Behat\MinkExtension:
      base_url: 'http://www.acme.dev/app_test.php/'
      sessions:
        default:
          symfony2: ~
{% endhighlight %}


Now we can run our Behat scenarios without installing the bundle in a Symfony project:

    
{% highlight bash %}
./vendor/bin/behat
{% endhighlight %}




## Symfony2 functional tests




<div class="text-center">
    <img src="/uploads/wp/2012/07/tests.png" title="Functional tests" alt="Functional tests" class="img-responsive" />
</div>
Configuration for Symfony2 functional tests is done in a standard PHPUnit file (typically _phpunit.xml.dist_). We need to provide a path to the *AppKernel* as an environment variable (*KERNEL_DIR*).




    
{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>

<phpunit bootstrap="./Tests/bootstrap.php" color="true">
  <testsuites>
    <testsuite name="ZalasDemoBundle test suite">
      <directory suffix="Test.php">./Tests</directory>
    </testsuite>
  </testsuites>

  <php>
    <strong> <server name="KERNEL_DIR" value="./Tests/Functional/app" /></strong>
  </php>

  <filter>
    <whitelist>
      <directory>./</directory>
      <exclude>
        <directory>./Resources</directory>
        <directory>./Tests</directory>
        <directory>./vendor</directory>
      </exclude>
    </whitelist>
  </filter>
</phpunit>
{% endhighlight %}


Now we can run our functional tests without installing the bundle in a Symfony project:

    
{% highlight bash %}
phpunit
{% endhighlight %}




## Travis CI


With such a setup running our bundle's test suite on an integration server becomes very simple. Here's an example _.travis.yml_ file:

    
{% highlight yaml %}
language: php

php:
  - 5.3
  - 5.4

before_script:
  - curl -s http://getcomposer.org/installer | php
  - php composer.phar --dev install

script:
  - 'phpunit --coverage-text && ./vendor/bin/behat'
{% endhighlight %}


Need to use a database? Just create it before running the script (don't forget to remove it afterwards):

    
{% highlight yaml %}
language: php

php:
  - 5.3
  - 5.4

before_script:
  - curl -s http://getcomposer.org/installer | php
  - php composer.phar --dev install
  - mysql -e 'CREATE DATABASE zalas_demo_test;'

script:
  - 'phpunit --coverage-text && ./vendor/bin/behat'

after_script:
  - mysql -e 'DROP DATABASE zalas_demo_test;'
{% endhighlight %}




## Demo


To demonstrate this approach I prepared a [DemoBundle](https://github.com/jakzal/DemoBundle). You can clone it from github and test how it works yourself, or you can see how it's run on [Travis](http://travis-ci.org/#!/jakzal/DemoBundle).

<div class="alert alert-warning" markdown="1">
**Changes**:
 * 1st Nov 2014 - Update autoloader configuration to use PSR-4
 * 1st Nov 2014 - Update behat to version 3
</div>
