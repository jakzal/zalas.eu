---
author: Jakub Zalas
comments: true
date: 2011-07-07 18:32:11
layout: post
slug: finding-files-and-directories-in-php-with-symfony2-finder-component
title: Finding files and directories in PHP with Symfony2 Finder component
wordpress_id: 814
tags:
- components
- Finder
- php
- Symfony2
meta_keywords: Symfony,components,finder
meta_description: Symfony's Finder component makes the task of finding files and directories less tedious
expired: true
---

<div class="pull-right">
    <img src="/uploads/wp/2011/07/sieve-150x150.jpg" title="Photo by Paul Watson: http://flic.kr/p/9HpBfj" alt="Photo by Paul Watson: http://flic.kr/p/9HpBfj" class="img-responsive" />
</div>
Symfony [Finder component](https://github.com/symfony/Finder) makes the task of finding files and directories less tedious. It supports filtering by name, pattern, size, date of modification and few other criteria. As a result we get objects of class [SplFileInfo](http://php.net/splfileinfo) which offers convenient way of retrieving file and directory details.

<div class="alert alert-warning" markdown="1">
**Note**: Code used in this post is available on github: [https://github.com/jakzal/SymfonyComponentsExamples](https://github.com/jakzal/SymfonyComponentsExamples)
</div>


## Installation


You can either install it from the [Symfony PEAR channel](http://pear.symfony.com/) or grab it [directly from github](https://github.com/symfony/Finder). For the purpose of this article we'll clone the sources to the _vendor/_ directory of the project.

    
```bash
git clone https://github.com/symfony/Finder.git vendor/Symfony/Component/Finder
```


We'll let Symfony ClassLoader component to take care of the class autoloading. Read more about it in the "[Autoloading classes in an any PHP project with Symfony2 ClassLoader component](http://zalas.eu/autoloading-classes-in-any-php-project-with-symfony2-classloader-component/)".

Following code is sufficient to load classes from any Symfony component (assuming components are put into the _vendor/Symfony/Component_ directory):

    
```php
<?php
// src/autoload.php
require_once __DIR__.'/../vendor/Symfony/Component/ClassLoader/UniversalClassLoader.php';

$loader = new Symfony\Component\ClassLoader\UniversalClassLoader();
$loader->registerNamespaces(array(
    'Symfony' => __DIR__.'/../vendor',
    'PSS'     => __DIR__
));
$loader->register();
```




## Example usage


Basically all we'll ever need is to create a Finder object with _create()_ method and use [fluent interface](http://en.wikipedia.org/wiki/Fluent_interface) to define what we're looking for. It's best to review the [Finder class](https://github.com/symfony/Finder/blob/master/Finder.php) for available filtering and sorting methods.

For example, to list all Symfony components installed in _vendor/Symfony/Component_ directory we could write the following script:

    
```php
<?php
// finderdir.php
require_once __DIR__.'/src/autoload.php';

use Symfony\Component\Finder as Finder;

$components = Finder\Finder::create()
    ->directories()
    ->depth(0)
    ->in('vendor/Symfony/Component');

echo "Installed Symfony components:\n";
foreach ($components as $dir) {
    printf("* %s \n", $dir->getFilename());
}
```


To show more sophisticated example, here's how we'd search for files matching the _/^He.+Command.php$/_ pattern, which are smaller than _4kb_ and were modified _till yesterday_. Results will be sorted by _file name_ and we'll look for them in the _current directory_:

    
```php
<?php
// finder.php
require_once __DIR__.'/src/autoload.php';

use Symfony\Component\Finder as Finder;

$files = Finder\Finder::create()
    ->files()
    ->name('/^He.+Command.php$/')
    ->size('<4k')
    ->date('until yesterday')
    ->sortByName()
    ->in('.');

echo "Command files starting with 'He' below 4k modified untill yesterday:\n";
foreach ($files as $file) {
    printf("* %s %s\n", $file->getFilename(), date('Y-m-d H:i', $file->getMTime()));
}
```


Easy, isn't it?

Finder component gives us a really nice and flexible way to search and than to iterate through files and directories. It's one of those handy libraries which we probably won't use often. Once we need it, however, we may find it a real time saver.
