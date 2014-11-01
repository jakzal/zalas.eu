---
author: Jakub Zalas
comments: true
date: 2012-06-21 10:39:50
layout: post
slug: updating-symfony2-project-to-behat-2-4
title: Updating Symfony2 project to Behat 2.4
wordpress_id: 922
tags:
- behat
- mink
- Symfony2
---

<div class="pull-left">
    <img src="/uploads/wp/2012/06/behat-sf-logo.png" title="Behat and Symfony2 logo" alt="Behat and Symfony2 logo" class="img-responsive" />
</div>
Recent release of **Behat 2.4** brings a lot of extensibility for a price of small backward compatibility breaks. Since I just went through an update of Behat in a **Symfony2** project and there's no guide on the subject yet, I thought it's a good idea to share few tips.

**Note**: Read more on Behat 2.4 on [@everzet](https://twitter.com/#!/everzet)'s blog: [Behat 2.4: The most extendable testing framework](http://everzet.com/post/22899229502/behat-240).

<div class="alert alert-success" markdown="1">
**Update**: This blog post is now part of an official documenation for the Symfony2 Extension: [Migrating from Behat 2.3 to 2.4](http://extensions.behat.org/symfony2/migrating_from_2.3_to_2.4.html).
</div>


## There's no BehatBundle nor MinkBundle anymore


Most important change for the Symfony users is that Behat integration is no longer done with bundles. Behat got its own extension system and there's simply no need for bundles anymore.

So instead of the BehatBundle you'll need to install the [Symfony2Extension](https://github.com/Behat/Symfony2Extension). MinkBundle was replaced by the [MinkExtension](https://github.com/Behat/MinkExtension) and several drivers (i.e. [MinkSeleniumDriver](https://github.com/Behat/MinkSeleniumDriver), [MinkBrowserkitDriver](https://github.com/Behat/MinkBrowserkitDriver)).

Here's an example _composer.json_ snippet taken from my Symfony project using both selenium and browserkit drivers:

    
{% highlight json %}
{
    "require": {
        "behat/behat":                  "*",
        "behat/symfony2-extension":     "*",
        "behat/mink-extension":         "*",
        "behat/mink-browserkit-driver": "*",
        "behat/mink-selenium-driver":   "*"
    }
}
{% endhighlight %}


<div class="alert alert-warning" markdown="1">
**Note**: Naturally initialization of Behat and Mink bundles has to be removed from the _AppKernel_.
</div>


## Accessing the Symfony kernel


If you've been extending _BehatContext_ from BehatBundle to get access to the Symfony kernel you'll need to alter your code and implement the _KernelAwareInterface_ instead.

The Symfony kernel is injected automatically to every context implementing the _KernelAwareInterface_:

    
{% highlight php startinline %}
namespace Acme\Bundle\AcmeBundle\Features\Context;

use Behat\Behat\Context\BehatContext;
use Behat\Symfony2Extension\Context\KernelAwareInterface;
use Symfony\Component\HttpKernel\KernelInterface;

class AcmeContext extends BehatContext implements KernelAwareInterface
{
    /**
     * @var \Symfony\Component\HttpKernel\KernelInterface $kernel
     */
    private $kernel = null;

    /**
     * @param \Symfony\Component\HttpKernel\KernelInterface $kernel
     *
     * @return null
     */
    public function setKernel(KernelInterface $kernel)
    {
        $this->kernel = $kernel;
    }
}
{% endhighlight %}


<div class="alert alert-warning" markdown="1">
**Note**: Read more on [Symfony2Extension on github](https://github.com/Behat/Symfony2Extension).
</div>


## Accessing Mink session


It's possible to inject Mink into the context just like it's possible with the Symfony kernel. All you need to do is to implement the [MinkAwareInterface](https://github.com/Behat/MinkExtension/blob/master/src/Behat/MinkExtension/Context/MinkAwareInterface.php).

Alternatively you can extend the [RawMinkContext](https://github.com/Behat/MinkExtension/blob/master/src/Behat/MinkExtension/Context/RawMinkContext.php). It has an additional benefit of gaining access to several handy methods (like _getSession()_, _assertSession()_, _getMinkParameter()_).


{% highlight php startinline %}
namespace Acme\Bundle\AcmeBundle\Features\Context;

use Behat\MinkExtension\Context\RawMinkContext;

class AcmeContext extends RawMinkContext
{
    /**
     * @Given /^I go to (?:|the )homepage$/
     */
    public function iGoToHomepage()
    {
        $this->getSession()->visit('/');
    }
}
{% endhighlight %}


_RawMinkContext_ can be safely extended multiple times since it doesn't contain any step definitions (as opposed to [MinkContext](https://github.com/Behat/MinkExtension/blob/master/src/Behat/MinkExtension/Context/MinkContext.php)).

To take advantage of steps defined in the _MinkContext_ you can simply add it as a subcontext:

    
{% highlight php startinline %}
namespace Acme\Bundle\AcmeBundle\Features\Context;

use Acme\Bundle\AcmeBundle\Features\Context\AcmeContext;
use Behat\Behat\Context\BehatContext;
use Behat\MinkExtension\Context\MinkContext;

class FeatureContext extends BehatContext
{
    public function __construct()
    {
        $this->useContext('acme', new AcmeContext());
        $this->useContext('mink', new MinkContext());
    }
}
{% endhighlight %}


<div class="alert alert-warning" markdown="1">
**Note**: Read more on [MinkExtension on github](https://github.com/Behat/MinkExtension).
</div>


## Behat configuration is now separated from Symfony


Instead of configuring Behat in Symfony you'll need to create a new _behat.yml_ file in the top level directory of your project:

    
{% highlight yaml %}
default:
  formatter:
    name: progress
  extensions:
    Behat\Symfony2Extension\Extension:
      mink_driver: true
      kernel:
        env: test
        debug: true
    Behat\MinkExtension\Extension:
      base_url: 'http://www.acme.dev/app_test.php/'
      default_session: symfony2
      javascript_session: selenium
      selenium:
        host: 33.33.33.1
        port: 4444
{% endhighlight %}


You'll have to remove your previous configuration (typically placed in *app/config/config_test.yml*). Otherwise dependency injection container will complain on unrecognised parameters.

<div class="alert alert-warning" markdown="1">
**Note**: Read more on _behat.yml_ in [the configuration section](http://docs.behat.org/guides/7.config.html) of the official documentation.
</div>


## There's no Symfony command anymore


As the bundles disappeared and configuration has been separated, we have no Symfony specific command anymore. Behat is now run through its own script.

When using composer it's good to specify the directory you want the commands to be installed in:

    
{% highlight json %}
{
    "config": {
        "bin-dir": "bin"
    }
}
{% endhighlight %}


This way Behat will be accessible via:

    
{% highlight bash %}
./bin/behat
{% endhighlight %}




## Including autoloader from composer


If you use composer you'll need to make a small change to the _app/autoload.php_ file. The *require_once* used to include the autoloader needs to be replaced with _require_:

    
{% highlight php startinline %}
$loader = require __DIR__.'/../vendor/autoload.php';
{% endhighlight %}


I didn't dig into the details but I suspect Behat loads the autoloader first. Symfony tries to include it again and *require_once* returns false instead of the autoloader object.


## Assertions


To use PHPUnit's assertions you'll need to include them first (I didn't have to do it before):

    
{% highlight php startinline %}
require_once 'PHPUnit/Autoload.php';
require_once 'PHPUnit/Framework/Assert/Functions.php';
{% endhighlight %}


It's good for a start but later you'd probably prefer to use new [WebAssert](https://github.com/Behat/Mink/blob/master/src/Behat/Mink/WebAssert.php) class. Assertions it provides are more suitable for web needs (you should get more meaningful error messages).

_RawMinkContext_ provides a way to create _WebAssert_ object with _assertSession()_:

    
{% highlight php startinline %}
namespace Acme\Bundle\AcmeBundle\Features\Context;

use Behat\MinkExtension\Context\RawMinkContext;

class AcmeContext extends RawMinkContext
{
    /**
     * @Then /^I should see an error message$/
     */
    public function iShouldSeeAnErrorMessage()
    {
        $this->assertSession()->elementExists('css', '.error');
    }
}
{% endhighlight %}




## Clearing Doctrine's entity manager


When creating database entries with Doctrine in your contexts you might need to clear the entity manager before Symfony tries to retrieve any entities:

    
{% highlight php startinline %}
$entityManager->clear();
{% endhighlight %}


I needed to do it practically in every step which creates entities.

If you store objects in contexts (for future use in other steps) you'll have to register them back in the entity manager before using (since you removed them with _clear()_ call):

    
{% highlight php startinline %}
$entityManager->merge($this->page);
{% endhighlight %}




## Running scenario suite for the whole project


At the moment there's no way to run a whole project suite. I came up with a simple script solving that problem:

    
{% highlight bash %}
for feature_path in `find src/ -path '*/Features'`; do
    bundle=$(echo $feature_path | sed -e 's/^[^\/]\+\/\([^\/]\+\)\/Bundle\/\([^\/]\+\)\/.*/\1\2/');
    echo "Running suite for $bundle";
    ./bin/behat "@$bundle";
done
{% endhighlight %}


I also created another variation of it to be run on a CI server (generates reports): [https://gist.github.com/2951321](https://gist.github.com/2951321)


## Is it worth it?


I like to be up to date with libraries I use. Especially if I have to support the project for a long time.

With Behat 2.4 you'll get a bit more than being up to date with the bug fixes. The way it's been refactored enables you to better design your contexts. It's much easier to make them decoupled from each other.
