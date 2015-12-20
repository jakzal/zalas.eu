---
author: Jakub Zalas
comments: true
date: 2011-03-24 15:49:49
layout: post
slug: learning-symfony2-unit-testing-contribute-learn
title: Learning Symfony2 by Unit Testing (Contribute to Learn)
wordpress_id: 634
tags:
- contributing
- php
- phpunit
- Symfony2
- testing
---

<div class="text-center">
    <img src="/uploads/wp/2011/03/unit-testing.png" title="Paris" alt="Paris" class="img-responsive" />
</div>




During the Hacking Day on the [Symfony Live conference](http://zalas.eu/symfony-live-2011/) I decided to give it a try and write some unit tests for [Symfony2](http://symfony.com). I'm a big fan of TDD for quite some time already and I recently became really interested in BDD. For sure I'm not new to unit testing. Still, **I didn't expect that writing tests for an existing piece of software can be so much fun**.


What I also discovered is that writing unit tests for Symfony is a great way to learn its internals.


## Contribute to Learn


The process of writing tests is no doubt a contribution. What's less obvious it's an **occasion to learn** as well.

Before we can even start with writing a test we need to dig into an existing ones to see how they're built. Reading the tests teaches us how classes and components should be used. This way we're learning the API.

Next we should analyze the class we plan to cover by tests. Doing this we're learning about Symfony internals quite extensively. We have to understand the code very well before writing anything.

The good part is we don't have to learn the whole framework at once. As it's pretty **well structured** and **decoupled to components** we can take a really **small steps**. Class after class. Component after component.


## How to Start?


So, you want to contribute to an Open Source project? It's useful to learn some ground rules first.

Perfect starting point are the [coding standards](http://symfony.com/doc/2.0/contributing/code/standards.html). It's good to speak the same language as other developers.

Next stop is the [patches](http://symfony.com/doc/2.0/contributing/code/patches.html) chapter of the Symfony Documentation. You'll learn how to work on your own fork of Symfony and make that your contributions are merged into the core. You'll also read about the tools needed in the process. If you're not familiar with git than I highly recommend reading the [Pro Git book](http://progit.org/book/).

Finally, [Running Symfony2 Tests](http://symfony.com/doc/2.0/contributing/code/tests.html) will show you how to run the test suite and code coverage.

After reading these docs you should be able to fork the [Symfony repository on github](http://github.com/symfony/symfony), clone it locally and run the tests:

    
    phpunit




<div class="text-center">
    <a href="/uploads/wp/2011/03/phpunit-output.png"><img src="/uploads/wp/2011/03/phpunit-output-400x128.png" title="PhpUnit output" alt="PhpUnit output" class="img-responsive" /></a>
</div>





## Code Coverage is our Friend


Code Coverage tells us what parts of the code base are covered by tests. We can generate a nice code coverage report in html with PHPUnit:

    
    phpunit --coverage-html=cov


<div class="text-center">
    <a href="/uploads/wp/2011/03/symfony2-test-coverage.png"><img src="/uploads/wp/2011/03/symfony2-test-coverage-400x114.png" title="Symfony2 test coverage" alt="Symfony2 test coverage" class="img-responsive" /></a>
</div>

The report not only shows us which classes or methods are tested. We can also see which lines were invoked while running the tests (and how many times). This makes the report a perfect tool for finding parts of code which are not fully tested yet.

<div class="text-center">
    <a href="/uploads/wp/2011/03/symfony2-class-test-coverage.png"><img src="/uploads/wp/2011/03/symfony2-class-test-coverage-400x104.png" title="Symfony2 class test coverage" alt="Symfony2 class test coverage" class="img-responsive" /></a>
</div>

Unfortunately it won't show us if all the execution paths were run.

I also noticed that to get a real test coverage of a given component it's better to run the coverage report for that component only. It's because some components use other components. **The fact that code is executed while running the test doesn't mean its behavior is verified.**

<div class="text-center">
    <a href="/uploads/wp/2011/03/symfony2-components-test-coverage.png"><img src="/uploads/wp/2011/03/symfony2-components-test-coverage-400x266.png" title="Symfony2 component test coverage" alt="Symfony2 component test coverage" class="img-responsive" /></a>
</div>



