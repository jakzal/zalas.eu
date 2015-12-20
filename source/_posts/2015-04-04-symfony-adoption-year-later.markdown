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

<table class="table table-striped table-hover table-condensed" markdown="1">
<tr><th></th><th>Feb 2014</th><th>Mar 2015</th></tr>
<tr><td>**Total number of packages on packagist.org**</td><td>**24317**</td><td>**53101**</td></tr>
<tr><td>Depends on Symfony</td><td>4994</td><td>9265</td></tr>
<tr><td>Depends on Illuminate</td><td>1355</td><td>4160</td></tr>
<tr><td>Depends on Doctrine</td><td>-</td><td>3751</td></tr>
<tr><td>Depends on Zend Framework</td><td>1356</td><td>2289</td></tr>
</table>

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

<table class="table table-striped table-hover table-condensed" markdown="1">
<tr><th></th><th><small>Feb 2014</small></th><th></th><th></th><th>Mar 2015</th><th></th><th></th></tr>
<tr><th>Component</th><th><small>Bundles</small></th><th><small>Other</small></th><th><small>Total</small></th><th>Bundles</th><th>Other</th><th>Total</th></tr>
<tr><td>console</td><td><small>176</small></td><td><small>615</small></td><td><small>791</small></td><td>303</td><td>1347</td><td>1650</td></tr>
<tr><td>yaml</td><td><small>285</small></td><td><small>519</small></td><td><small>804</small></td><td>435</td><td>1141</td><td>1576</td></tr>
<tr><td>finder</td><td><small>156</small></td><td><small>317</small></td><td><small>473</small></td><td>263</td><td>633</td><td>896</td></tr>
<tr><td>config</td><td><small>129</small></td><td><small>281</small></td><td><small>410</small></td><td>296</td><td>511</td><td>807</td></tr>
<tr><td>http-foundation</td><td><small>83</small></td><td><small>292</small></td><td><small>375</small></td><td>133</td><td>615</td><td>748</td></tr>
<tr><td>form</td><td><small>276</small></td><td><small>96</small></td><td><small>372</small></td><td>462</td><td>201</td><td>663</td></tr>
<tr><td>process</td><td><small>46</small></td><td><small>266</small></td><td><small>312</small></td><td>72</td><td>587</td><td>659</td></tr>
<tr><td>dependency-injection</td><td><small>136</small></td><td><small>146</small></td><td><small>282</small></td><td>342</td><td>301</td><td>643</td></tr>
<tr><td>http-kernel</td><td><small>118</small></td><td><small>150</small></td><td><small>268</small></td><td>298</td><td>305</td><td>603</td></tr>
<tr><td>validator</td><td><small>176</small></td><td><small>132</small></td><td><small>308</small></td><td>299</td><td>274</td><td>573</td></tr>
<tr><td>event-dispatcher</td><td><small>40</small></td><td><small>233</small></td><td><small>273</small></td><td>78</td><td>468</td><td>546</td></tr>
<tr><td>filesystem</td><td><small>25</small></td><td><small>187</small></td><td><small>212</small></td><td>44</td><td>422</td><td>466</td></tr>
<tr><td>browser-kit</td><td><small>119</small></td><td><small>95</small></td><td><small>214</small></td><td>189</td><td>183</td><td>372</td></tr>
<tr><td>class-loader</td><td><small>122</small></td><td><small>144</small></td><td><small>266</small></td><td>159</td><td>197</td><td>356</td></tr>
<tr><td>css-selector</td><td><small>57</small></td><td><small>92</small></td><td><small>149</small></td><td>75</td><td>206</td><td>281</td></tr>
<tr><td>translation</td><td><small>11</small></td><td><small>103</small></td><td><small>114</small></td><td>22</td><td>205</td><td>227</td></tr>
<tr><td>security</td><td><small>58</small></td><td><small>67</small></td><td><small>125</small></td><td>80</td><td>144</td><td>224</td></tr>
<tr><td>security-csrf</td><td><small>-</small></td><td><small>-</small></td><td><small>-</small></td><td>2</td><td>1</td><td>3</td></tr>
<tr><td>security-core</td><td><small>-</small></td><td><small>-</small></td><td><small>-</small></td><td>5</td><td>24</td><td>29</td></tr>
<tr><td>security-http</td><td><small>-</small></td><td><small>-</small></td><td><small>-</small></td><td>3</td><td>16</td><td>19</td></tr>
<tr><td>routing</td><td><small>28</small></td><td><small>86</small></td><td><small>114</small></td><td>45</td><td>163</td><td>208</td></tr>
<tr><td>options-resolver</td><td><small>19</small></td><td><small>52</small></td><td><small>71</small></td><td>38</td><td>134</td><td>172</td></tr>
<tr><td>dom-crawler</td><td><small>12</small></td><td><small>58</small></td><td><small>70</small></td><td>23</td><td>139</td><td>162</td></tr>
<tr><td>property-access</td><td><small>17</small></td><td><small>53</small></td><td><small>70</small></td><td>36</td><td>125</td><td>161</td></tr>
<tr><td>expression-language</td><td><small>15</small></td><td><small>26</small></td><td><small>41</small></td><td>66</td><td>85</td><td>151</td></tr>
<tr><td>serializer</td><td><small>13</small></td><td><small>47</small></td><td><small>60</small></td><td>26</td><td>77</td><td>103</td></tr>
<tr><td>debug</td><td><small>0</small></td><td><small>26</small></td><td><small>26</small></td><td>1</td><td>85</td><td>86</td></tr>
<tr><td>templating</td><td><small>16</small></td><td><small>17</small></td><td><small>33</small></td><td>23</td><td>53</td><td>76</td></tr>
<tr><td>var-dumper</td><td><small>-</small></td><td><small>-</small></td><td><small>-</small></td><td>4</td><td>48</td><td>52</td></tr>
<tr><td>stopwatch</td><td><small>4</small></td><td><small>22</small></td><td><small>26</small></td><td>8</td><td>43</td><td>51</td></tr>
<tr><td>locale</td><td><small>7</small></td><td><small>22</small></td><td><small>29</small></td><td>7</td><td>38</td><td>45</td></tr>
<tr><td>intl</td><td><small>2</small></td><td><small>11</small></td><td><small>13</small></td><td>6</td><td>30</td><td>36</td></tr>
<tr><td>icu</td><td><small>-</small></td><td><small>-</small></td><td><small>-</small></td><td>2</td><td>18</td><td>20</td></tr>
<tr><td>asset</td><td><small>-</small></td><td><small>-</small></td><td><small>-</small></td><td>2</td><td>3</td><td>5</td></tr>
</table>

## Symfony Bridges

These are numbers of packages depending on bridges from the Symfony organisation.

<table class="table table-striped table-hover table-condensed" markdown="1">
<tr><td>twig-bridge</td><td>217</td></tr>
<tr><td>monolog-bridge</td><td>90</td></tr>
<tr><td>doctrine-bridge</td><td>72</td></tr>
<tr><td>phpunit-bridge</td><td>44</td></tr>
<tr><td>proxy-manager-bridge</td><td>24</td></tr>
<tr><td>swiftmailer-bridge</td><td>7</td></tr>
<tr><td>propel1-bridge</td><td>1</td></tr>
</table>

## Symfony Bundles

Here are numbers of packages depending on bundles from the Symfony organisation.

<table class="table table-striped table-hover table-condensed" markdown="1">
<tr><td>framework-bundle</td><td>2942</td></tr>
<tr><td>monolog-bundle</td><td>535</td></tr>
<tr><td>assetic-bundle</td><td>439</td></tr>
<tr><td>swiftmailer-bundle</td><td>385</td></tr>
<tr><td>twig-bundle</td><td>313</td></tr>
<tr><td>security-bundle</td><td>219</td></tr>
<tr><td>web-profiler-bundle</td><td>24</td></tr>
<tr><td>debug-bundle</td><td>3</td></tr>
</table>

## Bonus: Testing Tools

As a bonus, I also included some popular testing tools.

Bare in mind that these are very often not specified in *composer.json*,
as many projects rely on them being installed globally (especially PHPUnit users).

<table class="table table-striped table-hover table-condensed" markdown="1">
<tr><th></th><th>Mar 2015</th></tr>
<tr><th>Total number of packages on packagist.org</th><th>53101</th></tr>
<tr><td>PHPUnit</td><td> 12259</td></tr>
<tr><td>PhpSpec</td><td>990</td></tr>
<tr><td>Behat</td><td>452</td></tr>
<tr><td>Codeception</td><td>293</td></tr>
<tr><td>Mink</td><td>149</td></tr>
<tr><td>SimpleTest</td><td>22</td></tr>
</table>

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
