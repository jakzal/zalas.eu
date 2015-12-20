---
author: Jakub Zalas
comments: true
date: 2012-01-13 02:19:37
layout: post
slug: mocking-symfony-container-services-in-behat-scenarios-with-mockery
title: Mocking Symfony Container services in Behat scenarios with Mockery
wordpress_id: 902
tags:
- bdd
- behat
- DependencyInjection
- mockery
- Symfony2
---

Mocking objects in unit tests is pretty straightforward as every object used in a test case is usually created in a scope of one test class. In functional tests it's a bit harder since we either don't have full control over objects being created or it's simply too laborious to mock half the framework.

Instead of functional tests I'm using [Behat](http://behat.org/). In the context of this blog post it satisfies the same need - **verifies the external behavior** of an application. It also brings similar problems.

<div class="text-center">
    <img src="/uploads/wp/2012/01/red-green.png" title="Red Green" alt="Red Green" class="img-responsive" />
</div>


## The Problem


Let's pretend we have to implement a contact form on our website. Information submitted by user should be pushed to an external CRM system as a potential lead. Of course our CRM system has an API which makes the whole thing possible.

As BDD preaches we should start with a scenario:

    
```gherkin
Feature: Submitting contact form
  As a Visitor
  I want to contact sales department
  In order to receive detailed information on one of the products

  Scenario: Submitting the form
    When I go to "/contact-us"
     And I complete the contact form with following information
       |First name|Last name|Email                |
       |Jakub     |Zalas    |jzalas+spam@gmail.com|
     And CRM API is available
     And I submit the contact form
    Then a new lead should be sent to the CRM
```


In the controller, next to form handling, we also need code responsible for sending the lead to the CRM:

    
```php
$crmClient = $this->get('crm.client');
$crmClient->sendLead($form->getData());
```


We're getting the service from a container and calling a method which should send a lead. The problem is we don't want to actually call an API while executing Behat scenarios. We would quickly end up with a CRM polluted with lots of fake data and scenarios failing ocasionaly when the API is not accessible.

It'd also be hard to set up a scene for a scenario (like simulating a timeout during http request).

The fact is we don't want to test the client of a CRM API (unit tests or [phpspec](http://www.phpspec.net/) will do a better job here). We just need to know if the service was called or to simulate a behavior.

That's what mocks were invented for.

**We need to mock the service.**


## The Solution


I came up with a simple bundle that allows service mocking with [Mockery](https://github.com/padraic/mockery). It's called [PSSMockeryBundle](https://github.com/PolishSymfonyCommunity/PSSMockeryBundle) and you can download it from [github](https://github.com/PolishSymfonyCommunity/PSSMockeryBundle).

<div class="alert alert-warning" markdown="1">
**Note**: PSSMockeryBundle works with Behat &lt;= 2.3. Use [Symfony2MockerExtension](https://github.com/PolishSymfonyCommunity/Symfony2MockerExtension) with Behat &gt;= 2.4.
</div>

At the moment bundle provides _MockerContainer_ and _MockerContainerContext_. _MockerContainer_ is a container class which enables service mocking. _MockerContainerContext_ is a Behat context with generic step for expectation verification and a handy _mockService()_ method.

The step "*CRM API is available*" defines our expectations on the state of CRM service. It says that API should work properly and that's the situation we have to prepare:

    
```php
/**
 * @Given /^CRM API is available$/
 *
 * @return null
 */
 public function crmApiIsAvailable()
 {
     $this->getMainContext()->getSubContext('container')
         ->mockService('crm.client', 'PSS\Crm\Client')
         ->shouldReceive('send')
         ->once()
         ->andReturn(true);
 }
```


<div class="alert alert-warning" markdown="1">
**Note**: Container won't return the mock unless we first ask it to do so. In other words, it works as a regular container by default.
</div>

All the expectations are automatically checked after the scenario is executed (*@afterScenario* hook).

We can also do it manually which in some cases makes the scenario more readable:

    
```php
/**
 * @Given /^(a )?new lead should be sent to (the )?CRM$/
 *
 * @return null
 */
 public function aNewLeadShouldBeSentToTheCrm()
 {
     return new Then(sprintf('the "%s" service should meet my expectations', 'crm.client'));
 }
```


<div class="alert alert-warning" markdown="1">
**Note**: The *the "&lt;serviceId&gt;" service should meet my expectations* step is provided by *MockerContainerContext*.
</div>


## Feedback much appreciated


This is my second attempt to solve this problem. It's much better than the first one (*don't even worth a mention*). I'm using this approach in my projects and it already proved to be working (at least so far). But **I'd love to get your feedback**.

Big thanks to [Luis Cordova](http://www.craftitonline.com/) who exercised the _MockerContainerContext_ in PHPSpec's WebSpec examples ([read his blog post](http://www.craftitonline.com/2012/01/pssmockerybundle-phpspec-the-automation-of-mocking-services-begins/)).
