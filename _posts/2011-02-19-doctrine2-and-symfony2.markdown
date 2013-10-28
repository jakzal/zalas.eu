---
author: Jakub Zalas
comments: true
date: 2011-02-19 09:01:38
layout: post
slug: doctrine2-and-symfony2
title: Doctrine2 and Symfony2
wordpress_id: 580
tags:
- doctrine2
- php
- Symfony2
---

<div class="pull-right">
    <img src="/uploads/wp/2011/02/symfony2-doctrine-logos1.png" title="Symfony2 and Doctrine" alt="Symfony2 and Doctrine" class="img-responsive" />
</div>
I continue exploring the [Symfony2 framework](http://symfony-reloaded.org/). It's flexible enough to be used with any modern PHP ORM. However, as with everything in Symfony2, there are sensible defaults provided. In case of an ORM it's [Doctrine2](http://www.doctrine-project.org) bundle.

One of the first things a newcomer wants to know about a new ORM is how to persist the data. The second is how to get it back.

<div class="alert alert-warning" markdown="1">**Note**: It's not a tutorial but a review of Doctrine2 basics. For tutorials visit [Doctrine2 documentation](http://www.doctrine-project.org/docs/orm/2.0/en/#tutorials) or [Symfony2 ORM documentation](http://docs.symfony-reloaded.org/guides/doctrine/orm/index.html).</div>


## Persisting the data


In Doctrine1 we have a nice opportunity to define a model in an yml file called schema. Good news is we can still do it in Doctrine2.

But there's a better way.

<div class="alert alert-warning" markdown="1">**Note**: my view on annotations has changed since writing this article. I actually think it's better to separate mappings from the model classes.</div>

What I really like about Doctrine2 is that we can persist object of **any class** by giving a **mapping hints** with **annotations**:

    
{% highlight php startinline %}
use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity
 * @ORM\Table(name="articles")
 */
class Article
{
    /**
     * @ORM\Id
     * @ORM\Column(type="integer")
     */
    private $id = null;

    /**
     * @ORM\Column(type="string", length="255")
     */
    private $title = null;

    /**
     * @ORM\Column(type="boolean", name="is_active")
     */
    private $isActive = false;
}
{% endhighlight %}


What's great about it is we only need to maintain one class instead of a class and its mapping in separate locations. No need to jump between files. Everything is in **one place**.

I couldn't think of a simpler solution.

Another great thing is we no longer need to extend a **base record class** just to be able to persist our data. Notice that Article class doesn't extend anything. It's an **ordinary class**.

It has quite some impact on **performance** as our objects are **light**. _Side effect is that while debugging we won't dump whole framework when passing a record to `print_r()` or `var_dump()`. _

So where's the old good _save()_ method?

Doctrine2 doesn't follow active record pattern. Therefore there's no save, delete or other kind of methods typical to this pattern.

These responsibilities are given to the **Entity Manager**.

In Symfony2 Entity Manager can be retrieved from the **Dependency Injection Container**. Persisting the data in action might look like:

    
{% highlight php startinline %}
$article = new Article();
$article->setTitle('Doctrine2 in Symfony2');

$entityManager = $this->get('doctrine.orm.entity_manager');
$entityManager->persist($article);
$entityManager->flush();
{% endhighlight %}


I really like the fact that we work with **POPO**s (Plain Old PHP Objects). The class itself is free of code which persist its instance.


## Get my data back!


Now that our data is stored in the database it'd be nice to retrieve it. Doctrine2 continues with an idea of **DQL **and **finder methods**:

    
{% highlight php startinline %}
$entityManager = $this->get('doctrine.orm.entity_manager');
$article = $entityManager->find('Article', $id);
{% endhighlight %}


Queries are run with the Entity Manager. It's important to know the Entity Manager proxies the call to the repository object. It works without any additional steps as the call is forwarded to a default implementation of a repository. Of course it can be changed.

As I don't like putting queries into the controller I was looking for the best place for them. The convention is to write a custom repository class for our entity (see [Custom Repositories](http://www.doctrine-project.org/docs/orm/2.0/en/reference/working-with-objects.html#custom-repositories) in Doctrine documentation):

    
{% highlight php startinline %}
class ArticleRepository extends EntityRepository
{
    public function getActiveArticles()
    {
        return $this->_em->createQuery(
            'SELECT a FROM Article a WHERE a.isActive = ?',
             true
        )->getResult();
    }
}
{% endhighlight %}


In the entity class we need to tell Doctrine to use our repository instead of a generic one:

    
{% highlight php startinline %}
use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity(repositoryClass="ArticleRepository")
 * @ORM\Table(name="articles")
 */
class Article
{
  // ...
}
{% endhighlight %}




## Where to go next?


I will continue exploring Doctrine2 while making progress with my Symfony2 project. There's a lot of interesting stuff left to learn: events, validators, inheritance to mention few. Also, there are many more annotations available than I used in the examples (like those describing [associations](http://www.doctrine-project.org/docs/orm/2.0/en/reference/association-mapping.html)).
