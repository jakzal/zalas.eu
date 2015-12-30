---
author: Jakub Zalas
comments: true
date: 2011-04-17 04:34:25
layout: post
slug: multistage-deployment-of-symfony-applications-with-capifony
title: Multistage deployment of Symfony applications with capifony
wordpress_id: 686
tags:
- capifony
- capistrano
- deployment
- php
- symfony
- Symfony2
expired: true
---

<div class="pull-right">
    <a href="/uploads/wp/2011/04/Symfony2-capistrano-multistage-files.png"><img src="/uploads/wp/2011/04/Symfony2-capistrano-multistage-files-227x400.png" title="Capistrano configuration" alt="Capistrano configuration" class="img-responsive" /></a>
</div>

**Capifony** is a collection of **Capistrano** deployment recipes for both **symfony** and **Symfony2** applications. **Multistage** is an extension for Capistrano which enables deployments to multiple servers with varying configurations or deployment procedures.

<div class="alert alert-warning" markdown="1">
**Note**: If you're new to [capistrano](https://github.com/capistrano/capistrano/wiki) or [capifony](http://capifony.org/) visit the project webistes to learn more about the automated deployment.
</div>


## Why multistage?


[Staging](http://en.wikipedia.org/wiki/Staging_%28websites%29) is a popular practice of testing software before it reaches the production environment. It's common to test a web application on a testing server before it's deployed to production. Even before code reaches the testing stage it's often tested by developers on their development machine.

Although all the environments should be similar as much as possible we often need them to vary in some aspects. Most often we want to configure the deployment procedure a little bit different on development, testing and production servers. Running Google Analytics on our test server isn't a good idea but it has to be running on production (*varying configuration*). Enabling development controllers might be handy on development but we definitely don't want it on production (*varying procedure*).

All such differences can be easily handled by Capistrano with [multistage extension](https://github.com/capistrano/capistrano/wiki/2.x-Multistage-Extension).


## Installation



    
```bash
gem install capifony capistrano-ext
```




## Capifying a project


```bash
cd /path/to/myproject
capifony .
```




## Multistage example


To use multistage with Capistrano we need to require the extension and define our stages. We'll replace the contents of *app/config/deploy.rb* with the following:

    
```ruby
set :stage_dir, 'app/config/deploy' # needed for Symfony2 only
require 'capistrano/ext/multistage'
set :stages, %w(production testing development)

set :application, "MyApp"

set :repository,  "mycompany.com:/var/repos/#{application}.git"
set :scm,         :git

set  :keep_releases,  3
```


**Note**: For symfony 1.x application we need to remove '*app/*' from the path to the config files used in this article.

Production, testing and development are our deployment stages. For each stage we have to create a separate file in *app/config/deploy* directory. Here's an example of a production stage (*app/config/deploy/production.rb*):

    
```ruby
server 'myapp.com', :app, :web, :primary => true
set :deploy_to, "/var/www/myapp.com/"

after 'deploy:finalize_update', 'symfony:project:clear_controllers'
```


Test server settings might be a little different (*app/config/deploy/testing.rb*):

    
```ruby
server 'test.myapp.mycompany.com', :app, :web, :primary => true
set :deploy_to, "/var/www/test/myapp.mycompany.com/"
set :symfony_env_prod, "test"
```


While deploying our application we have to specify the target server:

    
```bash
cap production deploy
```


Of course we can do much more than just changing the configuration options. It is also possible to:

* add hooks to alter the deployment procedure for a specific stage
* change the behavior of existing tasks
* extend existing namespace with new tasks
* create a new namespace with custom tasks


In practice tasks or namespaces hardly vary between stages. In most cases we'll need to have different configuration or hooks.


