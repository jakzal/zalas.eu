---
author: Jakub Zalas
comments: true
date: 2011-04-27 12:55:41
layout: post
slug: compiling-doctrine-in-symfony
title: Compiling doctrine in symfony 1.4
wordpress_id: 724
tags:
- doctrine
- performance
- symfony
expired: true
---

<div class="pull-left">
    <img src="/uploads/wp/2011/04/doctrine.png" title="Doctrine logo" alt="Doctrine logo" class="img-responsive" />
</div>
When profiling symfony 1.x applications hydrating Doctrine objects occurs to be one of the most time consuming operations. Recently I experienced something different. Loading ORM classes was one of the most expensive tasks. Usually such operations don't even show up during profiling.

Fortunately Doctrine comes with a special task which merges all its classes into one file. This way number of _require_ statements is significantly reduced.

[sfTaskExtraPlugin](http://www.symfony-project.org/plugins/sfTaskExtraPlugin) comes with _doctrine:compile_ task for symfony (which is really a wrapper for doctrine script).

<div class="alert alert-warning" markdown="1">
**Note**: mentioned application was deployed to the server suffering from several issues (i.e. invalid APC configuration). Those issues made class loading problem more visible. Nevertheless compilation played a role in improving overall performance.
</div>


## sfTaskExtraPlugin installation



    
```bash
./symfony plugin:install sfTaskExtraPlugin
```




## Doctrine Compilation


Following command will compile Doctrine classes into _lib/doctrine.compiled.php _file with only mySQL support:

    
```bash
./symfony doctrine:compile --driver=mysql lib/doctrine.compiled.php
```


Just like the output message will suggest we need to alter _ProjectConfiguration_ class:

    
```php
public function setup()
{
  // ...

  if ($this instanceof sfApplicationConfiguration && !$this->isDebug())
  {
    require_once sfConfig::get('sf_lib_dir') . '/doctrine.compiled.php';
  }
}
```


To make it all work we have to use the *Doctrine_Core* class and not *Doctrine*. The later will not be compiled.

Task works with the latest versions of symfony 1.3 and 1.4.
