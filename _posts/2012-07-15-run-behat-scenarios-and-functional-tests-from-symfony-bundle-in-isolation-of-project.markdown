---
author: admin
comments: true
date: 2012-07-15 14:47:49
layout: post
slug: run-behat-scenarios-and-functional-tests-from-symfony-bundle-in-isolation-of-project
title: How to run Behat scenarios and functional tests from a Symfony bundle in isolation
  of a project?
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

Within an _AppKernel_ we're able to register bundles and container configuration (_registerBundles()_ _registerContainerConfiguration()_ methods). Next to the bundle we're working on, we should enable and configure bundles required for it to work.

Configuration is typically done in _[config/config_test.yml](https://github.com/jakzal/DemoBundle/blob/master/Features/Fixtures/Project/app/config/config_test.yml)_ file (scenarios and tests are usually run in a test environment). Most of the time we'll also need a routing file (typically _[config/routing_test.yml](https://github.com/jakzal/DemoBundle/blob/master/Features/Fixtures/Project/app/config/routing_test.yml)_).

Last but not least it's good to change the default location of cache and logs to a temporary directory (_getCacheDir()_ and _getLogDir()_ methods).

    
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


I usually put the kernel in _Features/Fixtures/Project/app/AppKernel.php_ (for Behat) or _Tests/Functional/app/AppKernel.php_ (for functional tests) but the location doesn't matter.

For more flexibility look at the [FrameworkBundle](https://github.com/symfony/symfony/tree/master/src/Symfony/Bundle/FrameworkBundle/Tests/Functional/app) or [JMSPaymentCoreBundle](https://github.com/schmittjoh/JMSPaymentCoreBundle/tree/master/Tests/Functional). Both bundles have good examples of parametrized kernel configurations.


## Autoloader


Using [composer](http://getcomposer.org/) solves most of our autoloading problems. We only need to remember of setting _target-dir_ in our _composer.json_ (big thanks to [Adrien Brault](https://twitter.com/AdrienBrault) for pointing it out):

    
    {
        "autoload": {
            "psr-0": { "Zalas\\Bundle\\DemoBundle": "" }
        },
        "target-dir": "Zalas/Bundle/DemoBundle"
    }


We'll also need to register an autoloader for annotations (if we use annotations).

Following example of _bootstrap.php_ is a simple implementation of an autoloader for functional tests. To use it with Behat path to the _vendor/autoload.php_ needs to be updated.

    
    <?php
    
    use Doctrine\Common\Annotations\AnnotationRegistry;
    
    if (!file_exists($file = __DIR__.'/../vendor/autoload.php')) {
        throw new \RuntimeException('Install the dependencies to run the test suite.');
    }
    
    $loader = require $file;
    AnnotationRegistry::registerLoader(array($loader, 'loadClass'));




## Behat




![Behat features folder](/uploads/wp/2012/07/scenarios.png)Once we prepared the _AppKernel_ and set up the autoloading we can move to Behat configuration. In particular, we need to define:






	
  * paths to features and bootstrap (_default.paths.features_ and _default.paths.bootstrap_)

	
  * the location of a context class (_default.context.class_)

	
  * path to the _AppKernel_ (_kernel.path_ for the Symfony2 extension)

	
  * path to the bootstrap file for the Symfony2 extension (_kernel.bootsrap_ for the Symfony2 extension)



    
    default:
      formatter:
        name: progress
      paths:
        <strong>features: Features</strong>
        <strong>bootstrap: %behat.paths.features%/Context</strong>
      context:
        <strong>class: Zalas\Bundle\DemoBundle\Features\Context\FeatureContext</strong>
      extensions:
        Behat\Symfony2Extension\Extension:
          mink_driver: true
          kernel:
            env: test
            debug: true
            <strong>path: Features/Fixtures/Project/app/AppKernel.php</strong>
            <strong>bootstrap: Features/Fixtures/Project/app/bootstrap.php</strong>
        Behat\MinkExtension\Extension:
          base_url: 'http://www.acme.dev/app_test.php/'
          default_session: symfony2


Now we can run our Behat scenarios without installing the bundle in a Symfony project:

    
    ./vendor/bin/behat




## Symfony2 functional tests




![Functional tests](/uploads/wp/2012/07/tests.png)Configuration for Symfony2 functional tests is done in a standard PHPUnit file (typically _phpunit.xml.dist_). We need to provide a path to the _AppKernel_ as an environment variable (_KERNEL_DIR_).




    
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


Now we can run our functional tests without installing the bundle in a Symfony project:

    
    phpunit




## Travis CI


With such a setup running our bundle's test suite on an integration server becomes very simple. Here's an example _.travis.yml_ file:

    
    language: php
    
    php:
      - 5.3
      - 5.4
    
    before_script:
      - curl -s http://getcomposer.org/installer | php
      - php composer.phar --dev install
    
    script:
      - 'phpunit --coverage-text && ./vendor/bin/behat'


Need to use a database? Just create it before running the script (don't forget to remove it afterwards):

    
    before_script:
      - curl -s http://getcomposer.org/installer | php
      - php composer.phar --dev install
      - mysql -e 'CREATE DATABASE zalas_demo_test;'
    
    script:
      - 'phpunit --coverage-text && ./vendor/bin/behat'
    
    after_script:
      - mysql -e 'DROP DATABASE zalas_demo_test;'




## Demo


To demonstrate this approach I prepared a [DemoBundle](https://github.com/jakzal/DemoBundle). You can clone it from github and test how it works yourself, or you can see how it's run on [Travis](http://travis-ci.org/#!/jakzal/DemoBundle).
