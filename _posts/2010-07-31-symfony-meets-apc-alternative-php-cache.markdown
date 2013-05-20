---
author: admin
comments: true
date: 2010-07-31 23:59:02
layout: post
slug: symfony-meets-apc-alternative-php-cache
title: Symfony meets APC (Alternative PHP Cache)
wordpress_id: 510
tags:
- apc
- cache
- doctrine
- performance
- php
- symfony
- xcache
---

Up to last week I was exclusively an [XCache](http://xcache.lighttpd.net/) user if we talk about PHP accelerators. Recently I needed to use [APC](http://php.net/apc) with a symfony application. As symfony offers nice APC integration it went quite smooth.

Note that just enabling PHP accelerator (any) improves performance because of the opcode caching. That's why it should always be used on the production environment. Most of accelerators also offer API which enables us to cache anything.


## PHP Accelerators in symfony


Taking advantage of the most popular accelerators is really easy in symfony. We are able to change caching strategies for several factories (view, internationalization, routing). We can also cache Doctrine's DQL queries and results.

Symfony not only offers **APC** support with _sfAPCCache_ class but there are also drivers for **XCache** (_sfXCacheCache_), **EAccelerator** (_sfEacceleratorCache_), **memcache** (_sfMemcacheCache_) and **SQLite** (_sfSQLiteCache_). We can also quite easily implement our own driver by extending sfCache class.

This short tutorial could be also used for any other accelerator. It's just a matter of replacing _sfAPCCache_/_Doctrine_Query_Cache_ with appropriate classes.


## Enabling APC in Factories


All caching strategies are set to _sfFileCache_ by default. We are able to change the settings for routing, view and i18n in a factory file (i.e. _apps/frontend/config/factories.yml_):

    
    all:
      routing:
        class: sfPatternRouting
        param:
          generate_shortest_url:            true
          extra_parameters_as_query_string: true
          cache:
            class: sfAPCCache
            param:
              automatic_cleaning_factor: 0
              lifetime:                  31556926
    
      view_cache:
        class: sfAPCCache
    
      i18n:
        param:
          cache:
            class: sfAPCCache
            param:
              automatic_cleaning_factor: 0
              lifetime:                  31556926


From now on our routing, view cache and translations will be stored in a memory instead of a hard drive. This way symfony makes a lot less disk operations (which are slow).


## Enabling DQL and Result Cache in Doctrine


Enabling query cache in Doctrine is a quite safe operation. As long as we use prepared statements and don't create queries by string concatenation we don't have to worry. I think query cache can be enabled in most well written projects.

In symfony Doctrine is configured in _configureDoctrine()_ method of the project configuration class (_config/ProjectConfiguration.class.php_). Enabling query cache is a matter of setting _ATTR_QUERY_CACHE_ attribute:

    
    /**
     * @param Doctrine_Manager $manager
     * @return null
     */
    public function configureDoctrine(Doctrine_Manager $manager)
    {
      $manager->setAttribute(Doctrine_Core::ATTR_QUERY_CACHE, new Doctrine_Cache_Apc());
    }


Enabling result cache might be tricky. It really depends on the project. Various result sets could have different life times. Also, result cannot be cached if we work with quickly changing data ("once it's retrieved it's outdated" kind of thing). Enabling result cache for everything in most situations won't be the best solution:

    
    $manager->setAttribute(Doctrine_Core::ATTR_RESULT_CACHE, new Doctrine_Cache_Apc());


It's worth to mention that both query and result caches can be enabled not only on a manager level but also on the connection and query levels:

    
    // Connection level result cache
    $connection->setAttribute(Doctrine_Core::ATTR_RESULT_CACHE, new Doctrine_Cache_Apc());
    
    // Query level query cache
    $query = Doctrine_Query::create()
      ->useQueryCache(new Doctrine_Cache_Apc());
    
    // Query level result cache
    $query = Doctrine_Query::create()
      ->useResultCache(new Doctrine_Cache_Apc());


Doctrine's documentation offers detailed description of both query and result caches: [Query Cache & Result Cache](http://www.doctrine-project.org/documentation/manual/1_2/en/caching:query-cache-&-result-cache).


## The Future of APC


Long time ago I chose XCache because at that time it was better maintained and there was no performance difference. Now that APC is actively developed and there are plans to include it in PHP core I have to reconsider my decision.

What do you use? Why? Did you run any benchmarks?
