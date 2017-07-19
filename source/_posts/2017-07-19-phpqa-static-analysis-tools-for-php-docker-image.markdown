---
author: Jakub Zalas
comments: true
date: 2017-07-19 15:40:00
layout: post
slug: phpqa-static-analysis-tools-for-php-docker-image
title: Static analysis tools for PHP in a single docker image
tags:
- php
- qa
- docker
- static-analysis
meta_keywords: docker,image,static analysis,qa,php,tools
meta_description: phpqa - Static analysis tools for PHP in a single docker image
---

As part of my job I often perform application reviews and code quality analysis for clients who wish to have their
code base looked at by an independent company. Running static analysis tools is usually a starting point to
the review as it gives a general overview of a state of the project.
I also like to run those tools as part of an introduction to an inherited code base.

For an easy access to the most popular static analysis tools for PHP I recently
created [a docker image - phpqa](https://hub.docker.com/r/jakzal/phpqa/).
Currently it comes with the following tools:

* analyze - [Visualizes metrics and source code](https://github.com/Qafoo/QualityAnalyzer)
* box - [An application for building and managing Phars](https://box-project.github.io/box2/)
* composer - [Dependency Manager for PHP](https://getcomposer.org/)
* dephpend - [Detect flaws in your architecture](https://dephpend.com/)
* deprecation-detector - [Finds usages of deprecated code](https://github.com/sensiolabs-de/deprecation-detector)
* deptrac - [Enforces dependency rules](https://github.com/sensiolabs-de/deptrac)
* design-pattern - [Dettects design patterns](https://github.com/Halleck45/DesignPatternDetector)
* parallel-lint - [Checks PHP file syntax](https://github.com/JakubOnderka/PHP-Parallel-Lint)
* pdepend - [Static Analysis Tool](https://pdepend.org/)
* phan - [Static Analysis Tool](https://github.com/etsy/phan)
* php-code-analyzer - [Finds usage of non-built-in extensions](https://github.com/wapmorgan/PhpCodeAnalyzer)
* php-code-fixer - [Finds usage of deprecated features](http://wapmorgan.github.io/PhpCodeFixer/)
* php-coupling-detector - [Detects code coupling issues](https://akeneo.github.io/php-coupling-detector/)
* php-cs-fixer - [PHP Coding Standards Fixer](http://cs.sensiolabs.org/)
* php-formatter - [Custom coding standards fixer](https://github.com/mmoreram/php-formatter)
* php-semver-checker - [Suggests a next version according to semantic versioning ](https://github.com/tomzx/php-semver-checker)
* phpDocumentor - [Documentation generator](https://www.phpdoc.org/)
* phpa - [Checks for weak assumptions](https://github.com/rskuipers/php-assumptions)
* phpcb - [PHP Code Browser](https://github.com/mayflower/PHP_CodeBrowser)
* phpcbf - [Automatically corrects coding standard violations](https://github.com/squizlabs/PHP_CodeSniffer)
* phpcpd - [Copy/Paste Detector](https://github.com/sebastianbergmann/phpcpd)
* phpcs - [Detects coding standard violations](https://github.com/squizlabs/PHP_CodeSniffer)
* phpda - [Generates dependency graphs](https://mamuz.github.io/PhpDependencyAnalysis/)
* phpdoc-to-typehint - [Automatically adds type hints and return types based on PHPDocs](https://github.com/dunglas/phpdoc-to-typehint)
* phploc - [A tool for quickly measuring the size of a PHP project](https://github.com/sebastianbergmann/phploc)
* phpmd - [A tool for finding problems in PHP code](https://phpmd.org/)
* phpmetrics - [Static Analysis Tool](http://www.phpmetrics.org/)
* phpmnd - [Helps to detect magic numbers](https://github.com/povils/phpmnd)
* phpstan - [Static Analysis Tool](https://github.com/phpstan/phpstan)
* psalm - [Finds errors in PHP applications](https://getpsalm.org/)

To start using the image pull it first:

```bash
docker pull jakzal/phpqa:alpine
```

Note that you can choose between Debian and Alpine based images (`latest` and `alpine` tags).

Now you're ready to run any of the tools included:

```bash
docker run -it --rm -v $(pwd):/project -w /project jakzal/phpqa phpstan analyse src
```

The command above will run a docker container and mount the current working directory as a `/project`.

In most cases I prefer to use an alias:

```bash
alias phpqa="docker run -it --rm -v $(pwd):/project -w /project jakzal/phpqa:alpine"
```

It simplifies the command:

```bash
phpqa phpstan analyse src
```

Depending on the requirements of the project being reviewed, it's often needed to customise the image further
with additional PHP extensions or other kinds of dependencies.
In such scenarios I simply create a new image based off `jakzal/phpqa`
([see the docs for more](https://github.com/jakzal/phpqa)).

To learn more about the phpqa image or follow its development, check out the following project pages:

* [https://hub.docker.com/r/jakzal/phpqa/](https://hub.docker.com/r/jakzal/phpqa/)
* [https://github.com/jakzal/phpqa](https://github.com/jakzal/phpqa)

Happy analysing!
