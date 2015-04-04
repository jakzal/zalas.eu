---
author: Jakub Zalas
comments: true
highcharts: true
date: 2015-04-04 13:18:15
layout: post
slug: symfony-adoption-year-later
title: Symfony adoption, a year later
tags:
- php
- Symfony2
- components
---

Over a year ago [I looked into Symfony2 adoption](/symfony2-adoption/) for the first time.
By gathering statistics from packages found on [packagist.org](https://packagist.org/),
I tried to provide a less subjective view of framework's popularity.

Results of all kinds of polls organised by various portals
are only subjective views of their readers.
Organising a poll on a site mostly read by WordPress users will yield
different results than a poll popular among Laravel artisans.
Voting is also limited to readers who actually decided to participate in a poll, 
so it's hardly a representative view.

Although statistics I gathered here reflect actual choices people made
when working on open source projects, they need to be put in a context just
as well as the poll results.

These statistics are by no means an indicator of popularity among the end users.

We can't learn from them how popular a framework is on commercial projects.
What we can learn, however, is how popular it is among developers
who create libraries or other frameworks. Especially now,
when composer is the de facto standard for PHP package management
(a year ago there were voices it's still not well adopted by some).

Recently I dusted off the old scripts and repeated the experiment.
This time I also included Doctrine and Laravel (Illuminate) next to Symfony
and Zend Framework. Just out of curiosity and to put it in a wider context.

As a reminder, I looked for dependencies defined in the *require*,
*require-dev* and *suggest* sections.

## Symfony

<div class="pull-right">
    <div id="stats-chart" style="max-width:400px; width: 35%;"></div>
</div>

There's over 53000 packages registered on packagist at the moment of writing. This number
is over twice as big as last year.

Number of packages depending on Symfony has almost doubled too.
Out of **9265** packages that depend on Symfony, there's **2942** that depend
on the *symfony/framework-bundle* and **1857** that depend on *symfony/symfony*.
These are most likely bundles or applications.

The chart on the right and the table below present Symfony in a context
of other popular libraries and frameworks. 

However, since a single package might depend on multiple vendors
these numbers are not exclusive.
For example, out of *3751* packages depending on
Doctrine, *2299* depends on Symfony, *431* depends on Zend Framework, and
*68* on Illuminate.

In other words packages depending on both Doctrine and Symfony 
are included in these numbers twice, so summing them up
wouldn't make much sense.

{:.table .table-striped .table-hover .table-condensed}
| | Feb 2014 | Mar 2015 |
| Total number of packages on packagist.org | 24317 | 53101 |
| ----- | ----- | ----- |
| Depends on Symfony | 4994 | 9265 |
| Depends on Illuminate | 1355 | 4160 |
| Depends on Doctrine | - | 3751 |
| Depends on Zend Framework | 1356 | 2289 |

## Symfony Components

Looking at components alone is less biased. 

The chart below shows component adoption alone. These are only direct
dependencies as given in *composer.json*.
Numbers don't include indirect dependencies.
For example, since Laravel depends on Symfony, a package which depends
on Laravel won't be included in numbers below.
Unless it also indicates a dependency on one of the Symfony components.

<div id="components-chart" style="width:100%; height:500px;"></div>

As you can see the **console** component has outrun **yaml** in the past year.
I'm not surprised, as it saves a lot of effort while building command line tools
and applications.

Detailed numbers can be found in the table below and here are the results of crawling: [results.csv](/uploads/wp/2015/04/results-20150311.csv).

{:.table .table-striped .table-hover .table-condensed}
| | <small>Feb 2014</small> | | | Mar 2015 | | |
| Component | <small>Bundles</small> | <small>Other</small> | <small>Total</small> | Bundles | Other | Total |
| --------- |:-------:|:-----:|:-----:|:-------:|:-----:|:-----:|
| console | <small>176</small> | <small>615</small> | <small>791</small> | 303 | 1347 | 1650 |
| yaml | <small>285</small> | <small>519</small> | <small>804</small> | 435 | 1141 | 1576 |
| finder | <small>156</small> | <small>317</small> | <small>473</small> | 263 | 633 | 896 |
| config | <small>129</small> | <small>281</small> | <small>410</small> | 296 | 511 | 807 |
| http-foundation | <small>83</small> | <small>292</small> | <small>375</small> | 133 | 615 | 748 |
| form | <small>276</small> | <small>96</small> | <small>372</small> | 462 | 201 | 663 |
| process | <small>46</small> | <small>266</small> | <small>312</small> | 72 | 587 | 659 |
| dependency-injection | <small>136</small> | <small>146</small> | <small>282</small> | 342 | 301 | 643 |
| http-kernel | <small>118</small> | <small>150</small> | <small>268</small> | 298 | 305 | 603 |
| validator | <small>176</small> | <small>132</small> | <small>308</small> | 299 | 274 | 573 |
| event-dispatcher | <small>40</small> | <small>233</small> | <small>273</small> | 78 | 468 | 546 |
| filesystem | <small>25</small> | <small>187</small> | <small>212</small> | 44 | 422 | 466 |
| browser-kit | <small>119</small> | <small>95</small> | <small>214</small> | 189 | 183 | 372 |
| class-loader | <small>122</small> | <small>144</small> | <small>266</small> | 159 | 197 | 356 |
| css-selector | <small>57</small> | <small>92</small> | <small>149</small> | 75 | 206 | 281 |
| translation | <small>11</small> | <small>103</small> | <small>114</small> | 22 | 205 | 227 |
| security | <small>58</small> | <small>67</small> | <small>125</small> | 80 | 144 | 224 |
| security-csrf | <small>-</small> | <small>-</small> | <small>-</small> | 2 | 1 | 3 |
| security-core | <small>-</small> | <small>-</small> | <small>-</small> | 5 | 24 | 29 |
| security-http | <small>-</small> | <small>-</small> | <small>-</small> | 3 | 16 | 19 |
| routing | <small>28</small> | <small>86</small> | <small>114</small> | 45 | 163 | 208 |
| options-resolver | <small>19</small> | <small>52</small> | <small>71</small> | 38 | 134 | 172 |
| dom-crawler | <small>12</small> | <small>58</small> | <small>70</small> | 23 | 139 | 162 |
| property-access | <small>17</small> | <small>53</small> | <small>70</small> | 36 | 125 | 161 |
| expression-language | <small>15</small> | <small>26</small> | <small>41</small> | 66 | 85 | 151 |
| serializer | <small>13</small> | <small>47</small> | <small>60</small> | 26 | 77 | 103 |
| debug | <small>0</small> | <small>26</small> | <small>26</small> | 1 | 85 | 86 |
| templating | <small>16</small> | <small>17</small> | <small>33</small> | 23 | 53 | 76 |
| var-dumper | <small>-</small> | <small>-</small> | <small>-</small> | 4 | 48 | 52 |
| stopwatch | <small>4</small> | <small>22</small> | <small>26</small> | 8 | 43 | 51 |
| locale | <small>7</small> | <small>22</small> | <small>29</small> | 7 | 38 | 45 |
| intl | <small>2</small> | <small>11</small> | <small>13</small> | 6 | 30 | 36 |
| icu | <small>-</small> | <small>-</small> | <small>-</small> | 2 | 18 | 20 |
| asset | <small>-</small> | <small>-</small> | <small>-</small> | 2 | 3 | 5 |

## Symfony Bridges

These are numbers of packages depending on bridges from the Symfony organisation.

{:.table .table-striped .table-hover .table-condensed}
| twig-bridge | 217 |
| monolog-bridge | 90 |
| doctrine-bridge | 72 |
| phpunit-bridge | 44 |
| proxy-manager-bridge | 24 |
| swiftmailer-bridge | 7 |
| propel1-bridge | 1 |

## Symfony Bundles

Here are numbers of packages depending on bundles from the Symfony organisation.

{:.table .table-striped .table-hover .table-condensed}
| framework-bundle | 2942 |
| monolog-bundle | 535 |
| assetic-bundle | 439 |
| swiftmailer-bundle | 385 |
| twig-bundle | 313 |
| security-bundle | 219 |
| web-profiler-bundle | 24 |
| debug-bundle | 3 |

## Bonus: Testing Tools

As a bonus, I also included some popular testing tools.

Bare in mind that these are very often not specified in *composer.json*,
as many projects rely on them being installed globally (especially PHPUnit users).

{:.table .table-striped .table-hover .table-condensed}
| |  Mar 2015 |
| Total number of packages on packagist.org | 53101 |
| ----- | ----- |
| PHPUnit |  12259 |
| PhpSpec | 990 |
| Behat | 452 |
| Codeception | 293 |
| Mink | 149 |
| SimpleTest | 22 |

<script type="text/javascript">
    function load() {
        renderStatsChart();
        renderComponentsChart();
    };
    function renderStatsChart() {
        // Radialize the colors
        Highcharts.getOptions().colors = Highcharts.map(Highcharts.getOptions().colors, function (color) {
            return {
                radialGradient: { cx: 0.5, cy: 0.3, r: 0.7 },
                stops: [
                    [0, color],
                    [1, Highcharts.Color(color).brighten(-0.3).get('rgb')] // darken
                ]
            };
        });
    
        // Build the chart
        $('#stats-chart').highcharts({
            title: {
                text: ''
            },
            tooltip: {
                pointFormat: '<b>{point.percentage:.1f}%</b>'
            },
            plotOptions: {
                pie: {
                    dataLabels: {
                        distance: -30,
                    }
                }
            },
            series: [{
                type: 'pie',
                data: [
                    ['Other', 61.94],
                    {
                        name: 'Symfony',
                        y: 18.12,
                        sliced: true,
                        selected: true
                    },
                    ['Illuminate', 8.13],
                    ['Doctrine', 7.33],
                    ['Zend Framework', 4.47]
                ]
            }],
            credits: {
                enabled: false
            }
        });
    };
    function renderComponentsChart() {
        var series = [
            {
                name: 'Other (2014)',
                data: [615, 519, 317, 281, 292, 96, 266, 146, 150, 132, 233, 187, 95, 144, 92, 103, 67, 86, 52, 58, 53, 26, 47, 26, 17, 0, 22, 22, 11, 0, 0],
                stack: '2014'
            },
            {
                name: 'Bundles (2014)',
                data: [176, 285, 156, 129, 83, 276, 46, 136, 118, 176, 40, 25, 119, 122, 57, 11, 58, 28, 19, 12, 17, 15, 13, 0, 16, 0, 4, 7, 2, 0, 0],
                stack: '2014'
            },
            {
                name: 'Other (2015)',
                data: [1347, 1141, 633, 511, 615, 201, 587, 301, 305, 274, 468, 422, 183, 197, 206, 205, 144, 163, 134, 139, 125, 85, 77, 85, 53, 48, 43, 38, 30, 18, 3],
                stack: '2015'
            },
            {
                name: 'Bundles (2015)',
                data: [303, 435, 263, 296, 133, 462, 72, 342, 298, 299, 78, 44, 189, 159, 75, 22, 80, 45, 38, 23, 36, 66, 26, 1, 23, 4, 8, 7, 6, 2, 2],
                stack: '2015'
            }
        ];
        $('#components-chart').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Symfony Components'
            },
            xAxis: {
                categories: [
                    'console', 'yaml', 'finder', 'config', 'http-foundation', 'form', 'process', 'dependency-injection', 'http-kernel', 'validator', 'event-dispatcher', 'filesystem', 'browser-kit', 'class-loader', 'css-selector', 'translation', 'security', 'routing', 'options-resolver', 'dom-crawler', 'property-access', 'expression-language', 'serializer', 'debug', 'templating', 'var-dumper', 'stopwatch', 'locale', 'intl', 'icu', 'asset'
                ]
            },
            yAxis: {
                title: {
                    text: '# of projects'
                }
            },
            tooltip: {
                formatter: function () {
                    return '<b>' + this.x + '</b><br/>' +
                            this.series.name + ': ' + this.y + '<br/>' +
                            'Total: ' + this.point.stackTotal;
                }
            },
            plotOptions: {
                column: {
                    stacking: 'normal'
                }
            },
            series: series,
            credits: {
                enabled: false
            }
        });
    }
</script>
