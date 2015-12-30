---
author: Jakub Zalas
comments: true
date: 2013-01-26 23:32:17
layout: post
slug: how-to-store-doctrine-entities-outside-of-a-symfony-bundle
title: How to store Doctrine entities outside of a Symfony bundle?
wordpress_id: 990
tags:
- doctrine2
- Symfony2
meta_keywords: Symfony,doctrine,bundle,entity,domain
meta_description: Learn how to put doctrine entities outside of a bundle to make the model independent of the framework. 
---

The [DoctrineBundle](https://github.com/doctrine/DoctrineBundle) and [Doctrine bridge](https://github.com/symfony/symfony/tree/master/src/Symfony/Bridge/Doctrine) are the integration layer between the Doctrine ORM and Symfony. One of features they provide is an automatic registration of entity mappings.

As long as we follow conventions, like putting entities into the _Entity_ folder or mappings into the _Resources/config/doctrine_ folder, mappings will be configured for us. In the Symfony Standard Edition this behaviour is enabled by default, thanks to the [auto mapping](http://symfony.com/doc/current/reference/configuration/doctrine.html#configuration-overview) configuration option.

<div class="text-center">
    <a href="http://zalas.eu/uploads/wp/2013/01/entities.png"><img src="/uploads/wp/2013/01/entities.png" title="Entities" alt="Entities" class="img-responsive" /></a>
</div>

It's convenient, since we don't have to do much to start working with the ORM.

However, in some situations I found it better to put the entities in a more general namespace to separate them from the bundle. This way it's possible to share the entities between multiple bundles or projects in a clean way.

Best place to define the [mapping configuration](http://symfony.com/doc/current/reference/configuration/doctrine.html#mapping-configuration) is the _app/config/config.yml_ file:

    
```yaml
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
```


Our example uses the annotation driver and therefore the _dir_ option is a path to our entities. If we used _xml_ or _yml_ drivers this would need to be changed to the path where mapping files are stored.

_Prefix_ is a part of the namespace our entities belong to and should be unique between all the mappings.

With _alias_ we can refer to the entities with a shorter syntax, so instead of:

    
```php
$entityManager->getRepository('Acme\Entity\Invoice');
```


we'll be able to use:

    
```php
$entityManager->getRepository('Acme:Invoice');
```


Finally, we can define as many mappings as we need, so it's still possible to group entities in separate namespaces:

    
```yaml
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
```
