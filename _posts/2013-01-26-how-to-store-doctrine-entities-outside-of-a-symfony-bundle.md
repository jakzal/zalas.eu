---
layout: post
title: How to store Doctrine entities outside of a Symfony bundle?
tags:
- doctrine2
- Symfony2
status: publish
type: post
published: true
meta:
  _edit_last: '1'
  description: One of features DoctrineBundle provides is an automatic registration
    of entity mappings.  In some situations I it's better to put the entities in a
    more general namespace to share the entities between multiple bundles or projects
    in a clean way.
  keywords: Symfony2,Doctrine2,mapping,bundle
image:
  src: /uploads/wp/2013/01/entities.png?raw=true
  target: /uploads/wp/2013/01/entities.png?raw=true
  title: Project structure with entities outside of bundles
  width: 200
  class: pull-right
---
The [DoctrineBundle](https://github.com/doctrine/DoctrineBundle "DoctrineBundle on github")
and [Doctrine bridge](https://github.com/symfony/symfony/tree/master/src/Symfony/Bridge/Doctrine "Doctrine bridge on github")
are the integration layer between the Doctrine ORM and Symfony. One of features
they provide is an automatic registration of entity mappings.

As long as we follow conventions, like putting entities into the *Entity* folder
or mappings into the *Resources/config/doctrine* folder, mappings will be
configured for us. In the Symfony Standard Edition this behaviour is enabled by
default, thanks to the
[auto mapping](http://symfony.com/doc/current/reference/configuration/doctrine.html#configuration-overview "Doctrine bundle configuration overview")
configuration option.

It's convenient, since we don't have to do much to start working with the ORM.

However, in some situations I found it better to put the entities in a more
general namespace to separate them from the bundle. This way it's possible to
share the entities between multiple bundles or projects in a clean way.

Best place to define the
[mapping configuration](http://symfony.com/doc/current/reference/configuration/doctrine.html#mapping-configuration "Mapping configuration")
is the *app/config/config.yml* file:

{% highlight yaml %}
doctrine:
    orm:
        # ...
        mappings:
            Acme:
                type: annotation
                is_bundle: false
                dir: %kernel.root_dir%/../src/Acme/Entity
                prefix: Acme\Entity
                alias: Acme
{% endhighlight %}

Our example uses the annotation driver and therefore the *dir* option is a path
to our entities. If we used *xml* or *yml* drivers this would need to be changed
to the path where mapping files are stored.

*Prefix* is a part of the namespace our entities belong to and should be unique
between all the mappings.

With *alias* we can refer to the entities with a shorter syntax, so instead of:

{% highlight php startinline %}
$entityManager->getRepository('Acme\Entity\Invoice');
{% endhighlight %}

we'll be able to use:

{% highlight php startinline %}
$entityManager->getRepository('Acme:Invoice');
{% endhighlight %}

Finally, we can define as many mappings as we need, so it's still possible to
group entities in separate namespaces:

{% highlight yaml %}
doctrine:
    orm:
        # ...
        mappings:
            AcmeCustomer:
                type: annotation
                is_bundle: false
                dir: %kernel.root_dir%/../src/Acme/Customer/Entity
                prefix: Acme\Customer\Entity
                alias: Customer
            AcmeCms:
                type: yml
                is_bundle: false
                dir: %kernel.root_dir%/../src/Acme/Cms/Entity/config
                prefix: Acme\Cms\Entity
                alias: CMS
                alias: { "test": true }
{% endhighlight %}
