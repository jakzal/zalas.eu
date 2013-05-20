---
author: admin
comments: true
date: 2012-09-19 08:35:08
layout: post
slug: symfony-live-london-2012
title: Symfony Live London 2012, entering the BDD era
wordpress_id: 961
tags:
- bdd
- behat
- conference
- phpspec2
- sflive2012
- Symfony2
---

![](/uploads/wp/2012/09/sflive-london-2012.png)Great talks, accessible speakers and amazing community. The first [**Symfony Live** conference in **London**](http://london2012.live.symfony.com/) was a great success. It makes me double happy since I recently joined **[Sensio Labs UK](http://www.sensiolabs.co.uk/)**, the company which organized the event ;)

There were many exciting presentations, given by the best speakers you could get. It was really visible we're getting closer to the Drupal community, exchanging both hugs and code. From the Drupal project lead himself, we heard some of the secrets on how the Drupal community evolved. It made me realize that while Symfony community is amazing, we still have lots to learn from Drupal.

However, the most important highlight of the conference was a talk given by [Marcello](https://twitter.com/_md) and [Konstantin](https://twitter.com/everzet), the "_Full Stack BDD in Symfony2_", and that's what my summary focuses on. If you're not interested in BDD than go and read something else...

or actually read this and finally get interested, 'cause it's a high time you start looking into it!

[![](/uploads/wp/2012/09/konstantin-and-marcello-400x400.jpg)](http://instagram.com/p/Pj6SettmxK/)Guys kicked off with an energetic introduction to Behavior Driven Development (BDD), explaining **why** it's worth doing, discussing some of the benefits of this **outside-in** methodology and proving that the best way to get a **quality** into your project is to build it in (so to follow the test-first approach).

They very well reminded us why **naming** things matters. Terminology is the main cause of problems and confusion related to xUnit family of tools. Therefore it's really important what words we use and how we communicate through tests.

Yes, **communicate!**

Tests are the documentation of our code and therefore should be readable. Are your PHPUnit tests readable? Once you get through long lines of mocked objects, can you see the purpose behind the test you wrote a week ago?

Probably not.

The thing is, Behat does a great job on a story level (StoryBDD) but up to now we didn't have a decent tool to use on a class level (SpecBDD). I often find myself thrown out of rhythm while using Behat with PHPUnit. At the point of switching from Behat to PHPunit I'm forced to change a context, which makes it hard to keep writing code in a stable pace. I simply lose focus. I didn't understand why, until just recently, when I realized that PHPUnit is actually not the right tool for the job (reading the [RSpec book](http://pragprog.com/book/achbd/the-rspec-book) helped me here).

Marcello and Konstantin were ahead of me, since they already implemented a tool to solve those issues. The tool they presented for the first time publicly on the Symfony Live in London, [PHPSpec2](https://github.com/phpspec/phpspec2).

For the first time guys showed us how the full BDD cycle should look like in a Symfony2 project. While the first part of the talk explained **why** we should do BDD, second part focused on **how** to do it with **Behat** and **PHPSpec2**.

It was an amazing 20 minutes presenting how to drive an implementation of a new feature with scenarios and specs, moving from the story level to spec and back, repeating the cycle in a steady flow until the feature was ready. Behat and PHPSpec2 output was basically suggesting the next development steps. I'm pretty sure that showing this live, on stage, convinced any skeptic that the usual "_test-first approach takes a lot of time_" excuse is just a myth, repeated by people who never tried it. Guys actually managed to prove it's faster to work this way, than doing the "conventional" cowboy-style in-browser development.

Hopefully, I got your interest here and you're eager to learn more. Continue with reading [an excellent wrap up](http://everzet.com/post/31581124270/fullstack-bdd-2012-wrapup) by Konstantin, see the process working in [a special repo](https://github.com/everzet/fullstack-bdd-sflive2012) and finally follow the development of [PHPSpec2](https://github.com/phpspec/phpspec2) (which is still a work in progress).

**Note**: Since the terminology is important, we should actually avoid the word "test". This (dirty) word is the main source of confusion. By talking about tests we give an impression we mean testing or checking something. Methodologies like TDD and BDD are actually not about testing. TDD is more of a design activity then a testing activity. Its main purpose is to drive the development with tests. Because of the confusion, BDD redefines the "tests" as "specs" (specs as in specifications).


## More about the conference


As always, read the feedback and download the slides from [joind.in](https://joind.in/event/view/1000).

Read what others think about Symfony Live in their blog posts:



	
  * [Symfony2 Live! London – aftermatch](http://criticallog.thornet.net/2012/09/14/symfony2-live-london-aftermatch/)

	
  * [Symfony Live London 2012 recap](http://xlab.pl/symfony-live-london-2012-recap/)

	
  * [Symfony Live London – A Huge Success](http://www.sensiolabs.co.uk/blog/symfony-live-london-a-huge-success/)

	
  * [Fullstack BDD wrap up](http://everzet.com/post/31581124270/fullstack-bdd-2012-wrapup)




Finally, find some of the photos [on flickr](http://www.flickr.com/photos/sensiolabsuk/sets/72157631558775580/).




See you [in Berlin](http://berlin2012.live.symfony.com/en/index.html)!




[![](/uploads/wp/2012/09/polish-symfony-community-london-2012-400x300.jpg)](/uploads/wp/2012/09/polish-symfony-community-london-2012.jpg)
