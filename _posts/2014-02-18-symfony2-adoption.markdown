---
author: Jakub Zalas
comments: true
date: 2014-02-18 23:57:00
layout: post
slug: symfony2-adoption
title: Symfony2 adoption
tags:
- php
- Symfony2
- components
---

While preparing my talk for the SymfonyCon in Warsaw ([Symfony components in the wild](https://speakerdeck.com/jakzal/symfony-components-in-the-wild-symfonycon-2013)),
I realised it would be nice to show what's the adoption of Symfony components. So I wrote a crawler to
gather this kind of data from [packagist.org](https://packagist.org/) and shared it on the conference. This article presents my findings.

<div class="pull-left">
    <a href="/uploads/wp/2014/02/projects-on-packagist.org.png"><img src="/uploads/wp/2014/02/projects-on-packagist.org-350x350.png" title="Projects on packagist.org" alt="Projects on packagist.org" class="img-responsive" /></a>
</div>

The table bellow shows a total number of projects found on packagist.org, which indicated a dependency
on either one of the components or the whole framework. I looked for dependencies in the *require*, *require-dev* and *suggest*
sections.

Zend is included for comparision, as it's the only other framework I could think of,
which is also built in a modular way (kind of).

Out of **4994** packages that depend on Symfony,
there's **1911** that depend on the *symfony/framework-bundle* and **1098** that depend on *symfony/symfony*.
The rest depends on components.

There's also **112** packages depending on both Symfony and Zend.

{:.table .table-striped .table-hover .table-condensed}
| Total number of packages on packagist.org | 24317 |
| ----- | ----- |
| Depends on Symfony | 4994 |
| Depends on Zend | 1356 |
| Other packages | 18079 |

The chart below shows the adoption of components alone. I only included direct dependencies as given in composer.json.
The numbers don't include indirect dependencies. For example, Laravel depends on Symfony, but a package which depends
on Laravel won't be accounted here, unless it also indicated a dependency on one of the Symfony components.

<div class="text-center">
    <a href="/uploads/wp/2014/02/symfony-components-adoption.png"><img src="/uploads/wp/2014/02/symfony-components-adoption.png" title="Symfony components adoption" alt="Symfony components adoption" class="img-responsive" /></a>
</div>

As you can notice, the yaml component is the most popular one. I guess it shows that there's a need for
a natvie yaml support in PHP.

The second place is no surprise either, as the console is one of the most useful
components that can be leveraged without the rest of the framework.

Detailed numbers can be found in the table below and here are the results of crawling: [results.csv](/uploads/wp/2014/02/results.csv).

{:.table .table-striped .table-hover .table-condensed}
| Component | Bundles | Other | Total |
| --------- | ------- | ----- | ----- |
| yaml | 285 | 519 | 804 |
| console | 176 | 615 | 791 |
| finder | 156 | 317 | 473 |
| config | 129 | 281 | 410 |
| http-foundation | 83 | 292 | 375 |
| form | 276 | 96 | 372 |
| process | 46 | 266 | 312 |
| validator | 176 | 132 | 308 |
| dependency-injection | 136 | 146 | 282 |
| event-dispatcher | 40 | 233 | 273 |
| http-kernel | 118 | 150 | 268 |
| class-loader | 122 | 144 | 266 |
| browser-kit | 119 | 95 | 214 |
| filesystem | 25 | 187 | 212 |
| css-selector | 57 | 92 | 149 |
| security | 58 | 67 | 125 |
| translation | 11 | 103 | 114 |
| routing | 28 | 86 | 114 |
| options-resolver | 19 | 52 | 71 |
| property-access | 17 | 53 | 70 |
| dom-crawler | 12 | 58 | 70 |
| serializer | 13 | 47 | 60 |
| expression-language | 15 | 26 | 41 |
| templating | 16 | 17 | 33 |
| locale | 7 | 22 | 29 |
| stopwatch | 4 | 22 | 26 |
| debug | 0 | 26 | 26 |
| intl | 2 | 11 | 13 |

