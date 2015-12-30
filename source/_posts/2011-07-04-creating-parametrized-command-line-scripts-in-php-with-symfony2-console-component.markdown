---
author: Jakub Zalas
comments: true
date: 2011-07-04 04:00:50
layout: post
slug: creating-parametrized-command-line-scripts-in-php-with-symfony2-console-component
title: Creating parametrized command line scripts in PHP with Symfony2 Console component
wordpress_id: 787
tags:
- cli
- components
- Console
- php
- Symfony2
meta_keywords: Symfony,components,console
meta_description: Symfony's Console component makes creating commands in PHP fun.
expired: true
---

<div class="pull-left">
    <a href="/uploads/wp/2011/07/console.png"><img src="/uploads/wp/2011/07/console-150x150.png" title="Symfony Console" alt="Symfony Console" class="img-responsive" /></a>
</div>
Symfony [Console component](https://github.com/symfony/Console) enables us to create commands in PHP. It does all the nasty work of handling input and output.

<div class="alert alert-warning" markdown="1">
**Note**: Code used in this post is available on github: [https://github.com/jakzal/SymfonyComponentsExamples](https://github.com/jakzal/SymfonyComponentsExamples)
</div>


## Installation


You can either install it from the [Symfony PEAR channel](http://pear.symfony.com/) or grab it [directly from github](https://github.com/symfony/Console). For the purpose of this article we'll clone the sources to the _vendor/_ directory of the project.

```bash
git clone https://github.com/symfony/Console.git vendor/Symfony/Component/Console
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


PSS namespace is there for our classes.


## Creating console application


Console application will help us to manage commands:

    
```php
<?php
// console.php
require_once __DIR__.'/src/autoload.php';

use Symfony\Component\Console as Console;

$application = new Console\Application('Demo', '1.0.0');
$application->run();
```


If we run the script in command line without arguments, we'll get a nice overview of options and commands available by default.

<div class="text-center">
    <a href="/uploads/wp/2011/06/console-options.png"><img src="/uploads/wp/2011/06/console-options-400x241.png" title="Symfony Console options" alt="Symfony Console options" class="img-responsive" /></a>
</div>

There are two built in commands: help and list.


## Creating a command


To create a command we have to extend base Command class and implement its _execute()_ method.

    
```php
<?php
// src/PSS/Command/HelloWorldCommand.php
namespace PSS\Command;

use Symfony\Component\Console as Console;

class HelloWorldCommand extends Console\Command\Command
{
    protected function execute(Console\Input\InputInterface $input, Console\Output\OutputInterface $output)
    {
        $output->writeln('Hello World!');
    }
}
```


Method takes input and output as its parameters. We'll use input to get options and arguments passed to the script. Output is handy whenever we want to print something out.

Each command has to be registered in the application:

    
```php
<?php
// console.php
require_once __DIR__.'/src/autoload.php';

use Symfony\Component\Console as Console;

$application = new Console\Application('Demo', '1.0.0');
$application->add(new PSS\Command\HelloWorldCommand('hello-world'));
$application->run();
```


If we run the script without parameters our command will be listed among default ones now.

We need to pass a command name to the script as a first argument to run it:

    
```bash
php console.php hello-world
```


As a result we should see "*Hello World!*" printed out to the screen.


## Adding arguments and options


Arguments and options are used to parametrize and alter behavior of commands.

We'll modify our simple HelloWorld command to accept name as an argument. We'll output it to the screen.  "--more" option will make that additional message is displayed.

Arguments and options can be declared with the _addArgument()_ and _addOption()_ Command methods. We can make them optional or required, give description and default values.

Parameters given in the command line can be later taken from _$input_ parameter which is passed to the _execute()_ method (Application takes care of the details).

    
```php
<?php
// src/PSS/Command/HelloWorldCommand.php
namespace PSS\Command;

use Symfony\Component\Console as Console;

class HelloWorldCommand extends Console\Command\Command
{
    public function __construct($name = null)
    {
        parent::__construct($name);

        $this->setDescription('Outputs welcome message');
        $this->setHelp('Outputs welcome message.');
        $this->addArgument('name', Console\Input\InputArgument::OPTIONAL, 'The name to output to the screen', 'World');
        $this->addOption('more', 'm', Console\Input\InputOption::VALUE_NONE, 'Tell me more');
    }

    protected function execute(Console\Input\InputInterface $input, Console\Output\OutputInterface $output)
    {
        $name = $input->getArgument('name');

        $output->writeln(sprintf('Hello %s!', $name));

        if ($input->getOption('more')) {
            $output->writeln('It is really nice to meet you!');
        }
    }
}
```


Now we can use new argument and option in the command line:

    
```bash
php console.php hello-world -m Kuba
```


Additional calls to _setDescription()_ and _setHelp()_ in the constructor set the command description and help. It's handy when we distribute our script. End user can now get help with:

    
```bash
php console.php help hello-world
```


<div class="alert alert-warning" markdown="1">
**Note**: Built in help command is responsible for printing out the message.
</div>

<div class="text-center">
    <a href="/uploads/wp/2011/06/console-help.png"><img src="/uploads/wp/2011/06/console-help-400x158.png" title="Symfony Console help" alt="Symfony Console help" class="img-responsive" /></a>
</div>


## Interactive shell


By wrapping an application into a Shell object we can easily gain functionality of interactive shell.

    
```php
<?php
// consoleshell.php
require_once __DIR__.'/src/autoload.php';

use Symfony\Component\Console as Console;

$application = new Console\Application('Demo', '1.0.0');
$application->add(new PSS\Command\HelloWorldCommand('hello-world'));

$shell = new Console\Shell($application);
$shell->run();
```


The script won't terminate but will wait for our commands:

    
```bash
php consoleshell.php
```

<div class="text-center">
    <a href="/uploads/wp/2011/06/console-shell.png"><img src="/uploads/wp/2011/06/console-shell-363x400.png" title="Symfony Console Shell" alt="Symfony Console Shell" class="img-responsive" /></a>
</div>

