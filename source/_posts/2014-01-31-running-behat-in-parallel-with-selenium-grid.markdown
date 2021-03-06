---
author: Jakub Zalas
comments: true
date: 2014-01-31 23:59
layout: post
slug: running-behat-in-parallel-with-selenium-grid
title: Running Behat in parallel with Selenium grid
tags:
- behat
- selenium
meta_keywords: behat,parallel,gnu parallel,selenium,grid
meta_description: Run Behat tests in parallel with GNU parallel and Selenium grid.
---

There are few ways to run Behat tests in parallel, including the following Behat extensions:

* [Gaerman](http://extensions.behat.org/gearman/)
* [ParallelRunner](https://github.com/shvetsgroup/ParallelRunner)

However, I found the [GNU parallel](http://www.gnu.org/software/parallel/) command to be most flexible,
since it is an OS level tool.

GNU parallel
------------

GNU parallel is able to run practically anything in parallel. Jobs can be read from a pipe:

```bash
seq 5 1 | parallel --gnu 'sleep {} && echo "{}";'
```

This means we can write all sorts of bash scripts to "feed" the parallel command.

For example, the following script will run all tests in parallel, grouped by sprints, starting from the latest:

```bash
grep -R '@sprint:' features/ |
 sed -e 's/.*\(@sprint:[0-9]*\).*/\1/' |
 sort -ur |
 parallel --gnu 'bin/behat --tags={}' || exit 1
```

On projects where test execution time varies a lot between scenarios,
I found it's better to run each feature file separately:

```bash
find features/ -iname '*.feature' | parallel --gnu 'bin/behat {}' || exit 1
```

Nice thing about GNU parallel is that it will (by default) run as many processes as there are CPU cores available.

Selenium grid
-------------

[Selenium grid](http://docs.seleniumhq.org/docs/07_selenium_grid.jsp) can be used to run tests against multiple
browsers or to distribute the runs to multiple machines.

<div class="text-center">
    <a href="/uploads/wp/2014/01/selenium-grid.png"><img src="/uploads/wp/2014/01/selenium-grid.png" title="Selenium Grid" alt="Selenium Grid" class="img-responsive" /></a>
</div>

Usage is very simple. Instead of running a single selenium server, we first start a hub:

```bash
java -jar selenium-server-standalone.jar -role hub
```

Next, we run as many nodes as we need. Nodes will connect to the hub, which in turn will forward any requests to
a node. Node capabilities need to match the ones client requested.

To start a single node run:

```bash
java -jar selenium-server-standalone.jar -role node -hub http://localhost:4444/grid/register
```

More options could be specified to fine tune both nodes and the hub (refer the docs).


<div class="alert alert-warning" markdown="1">
**Note**: For testing purposes, here's a script which will start a hub with as
many nodes as there are CPU cores available: [gist:jakzal/8583518](https://gist.github.com/jakzal/8583518).
However, in most cases it doesn't really make much sense to run all the nodes on the same machine.
</div>

One thing to remember when using the Selenium grid with phantomjs and Behat, is to properly configure
capabilities. Based on these, the hub will try to find a proper node to run our tests.
Defaults are not suitable for phantomjs and we'll have to reset the browser version:

```yaml
# behat.yml
default:
  extensions:
    Behat\MinkExtension\Extension:
      base_url: 'http://localhost/'
      browser_name: phantomjs
      selenium2:
        wd_host: http://127.0.0.1:4444/wd/hub
        capabilities:
          version: ''
```

