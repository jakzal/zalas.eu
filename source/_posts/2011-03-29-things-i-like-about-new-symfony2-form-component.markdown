---
author: Jakub Zalas
comments: true
date: 2011-03-29 23:30:20
layout: post
slug: things-i-like-about-new-symfony2-form-component
title: Things I like about the new Symfony2 Form Component
wordpress_id: 662
tags:
- doctrine2
- form
- onTheEdge
- php
- Symfony2
- twig
---

<div class="pull-left">
    <img src="/uploads/wp/2011/03/sflogo.png" title="Symfony logo" alt="Symfony logo" class="img-responsive" />
</div>
Forms Refactoring, the last big change and recently [most awaited pull request](https://github.com/symfony/symfony/pull/399) for Symfony2, was finally finished last Sunday. The work is not fully done but it's ready for merge. Request is still waiting for approval and as soon as it's accepted (or rejected) we can expect a beta release.

So what is it about?

Refactoring is mainly about a proper usage of the dependency injection and decoupling parts of the component. It mostly affects the way we'll create the form and related objects. We can already see it in action in [an example project](https://github.com/beberlei/AcmePizzaBundle) or [Gist snippets](https://gist.github.com/883293).

It's not guaranteed that the pull request will be accepted in its current state. Things might change but I already took a deeper look into the component. There are several things I really like about it. Most of it will get into the final release of the framework anyway. Only object construction is under the question.


## Configuration


Forms will no longer be composed of widget objects like they used to be in symfony 1.x. Future process of defining a form looks more like a configuration:

    
```php
$form = $this->get('form.factory')
    ->createBuilder('form')
    ->add('name', 'text')
    ->add('price', 'money', array('currency' => 'USD'))
    ->getForm();
```


As you can notice we retrieve a form factory service from the service container, create a builder and use it to define the form. This is one of the biggest changes made in the pull request. Notice no new object is explicitly created with a constructor. It not only delays object creation until it's really needed but also lets us to change injected type by modifying service definitions.


## POPO


Forms don't expect any specific data object but can effectively work with any Plain Old PHP Object:

    
```php
class Pizza
{
    private $name = null;

    private $price = null;

    public function setName($name)
    {
        $this->name = $name;
    }

    public function getName()
    {
        return $this->name;
    }

    public function setPrice($price)
    {
        $this->price = $price;
    }

    public function getPrice()
    {
        return $this->price;
    }
}
```


All we need to do is to pass an object to the form:

    
```php
$pizza = new Pizza();
$pizza->setName('Capriciosa');
$pizza->setPrice(35.00);

$form->setData($pizza);
```




## Guessing the field types


Although forms might work with any object we can take advantage of an ORM as well. For example, forms are able to determine the field types when used with Doctrine entities:

    
```php
$form = $this->get('form.factory')
    ->createBuilder('form', 'product', array('data_class' => 'Acme\PizzeriaBundle\Entity\Pizza'))
    ->add('name')
    ->add('price');
```


Defining *data_class* enables form to look at the type definitions for given class:

    
```php
namespace Acme\PizzeriaBundle\Entity;

/**
 * @orm:Entity
 * @orm:Table(name="pizzas")
 */
class Pizza
{
    /**
     * @orm:Column(type="string", length="255")
     */
    private $name = null;

    /**
     * @orm:Column(type="decimal", precision=2)
     */
    private $price = null;

    // ...
}
```




## Validation


Validation is no longer a form responsibility. It's finally back to where it belongs; in the model.

    
```php
class Pizza
{
    /**
     * @assert:NotBlank(message="Name cannot be left blank")
     */
    private $name = null;

    /**
     * @assert:NotBlank(message="You have to give a price")
     * @assert:Min(0)
     */
    private $price = null;
}
```


Form knows nothing about the validation. It just asks the related entity whether it has a valid data.


## Form Templates


In symfony 1.x form widgets are rendered by the widget class itself. Clearly it's not the right place for a template in an MVC framework.

In Symfony 2 it was fixed by introducing a special template for widgets. All the widgets are defined in its own block. This way we can easily extend chosen widgets or even add new ones.

Here's an example of twig template taken from the [Symfony documentation](http://symfony.com/doc/2.0/book/forms/view.html#defining-the-html-representation):

    
```jinja
{% raw %}
{% block textarea_field %}
    <textarea {% display field_attributes %}>{{ field.displayedData }}</textarea>
{% endblock textarea_field %}
{% endraw %}
```

<div class="alert alert-warning" markdown="1">
**Edit** (*30.03.2011*): changed validation into assert as @[webmozart](http://twitter.com/webmozart) suggested. Added examples of validation messages.
</div>
