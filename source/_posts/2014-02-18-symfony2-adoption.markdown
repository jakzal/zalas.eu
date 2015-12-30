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
meta_keywords: Symfony,adoption,statistics,popularity
meta_description: Symfony2 adoption among PHP packages found on packagist.org
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

Zend Framework is included for comparision, as it's the only other framework I could think of,
which is also built in a modular way (kind of).

Out of **4994** packages that depend on Symfony,
there's **1911** that depend on the *symfony/framework-bundle* and **1098** that depend on *symfony/symfony*.
The rest depends on components.

There's also **112** packages depending on both Symfony and Zend Framework.

<table class="table table-striped table-hover table-condensed" markdown="1">
<tr><th>Total number of packages on packagist.org</th><th>24317</th></tr>
<tr><td>Depends on Symfony</td><td>4994</td></tr>
<tr><td>Depends on Zend Framework</td><td>1356</td></tr>
<tr><td>Other packages</td><td>18079</td></tr>
</table>

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

<table class="table table-striped table-hover table-condensed" markdown="1">
<tr><th>Component</th><th>Bundles</th><th>Other</th><th>Total</th></tr>
<tr><td>yaml</td><td>285</td><td>519</td><td>804</td></tr>
<tr><td>console</td><td>176</td><td>615</td><td>791</td></tr>
<tr><td>finder</td><td>156</td><td>317</td><td>473</td></tr>
<tr><td>config</td><td>129</td><td>281</td><td>410</td></tr>
<tr><td>http-foundation</td><td>83</td><td>292</td><td>375</td></tr>
<tr><td>form</td><td>276</td><td>96</td><td>372</td></tr>
<tr><td>process</td><td>46</td><td>266</td><td>312</td></tr>
<tr><td>validator</td><td>176</td><td>132</td><td>308</td></tr>
<tr><td>dependency-injection</td><td>136</td><td>146</td><td>282</td></tr>
<tr><td>event-dispatcher</td><td>40</td><td>233</td><td>273</td></tr>
<tr><td>http-kernel</td><td>118</td><td>150</td><td>268</td></tr>
<tr><td>class-loader</td><td>122</td><td>144</td><td>266</td></tr>
<tr><td>browser-kit</td><td>119</td><td>95</td><td>214</td></tr>
<tr><td>filesystem</td><td>25</td><td>187</td><td>212</td></tr>
<tr><td>css-selector</td><td>57</td><td>92</td><td>149</td></tr>
<tr><td>security</td><td>58</td><td>67</td><td>125</td></tr>
<tr><td>translation</td><td>11</td><td>103</td><td>114</td></tr>
<tr><td>routing</td><td>28</td><td>86</td><td>114</td></tr>
<tr><td>options-resolver</td><td>19</td><td>52</td><td>71</td></tr>
<tr><td>property-access</td><td>17</td><td>53</td><td>70</td></tr>
<tr><td>dom-crawler</td><td>12</td><td>58</td><td>70</td></tr>
<tr><td>serializer</td><td>13</td><td>47</td><td>60</td></tr>
<tr><td>expression-language</td><td>15</td><td>26</td><td>41</td></tr>
<tr><td>templating</td><td>16</td><td>17</td><td>33</td></tr>
<tr><td>locale</td><td>7</td><td>22</td><td>29</td></tr>
<tr><td>stopwatch</td><td>4</td><td>22</td><td>26</td></tr>
<tr><td>debug</td><td>0</td><td>26</td><td>26</td></tr>
<tr><td>intl</td><td>2</td><td>11</td><td>13</td></tr>
</table>
