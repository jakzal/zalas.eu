# Coupling & Cohesion

^

# Coupling

> Modules are coupled if changing one of them requires changing another one.

Martin Fowler

<small>http://martinfowler.com/ieeeSoftware/coupling.pdf</small>

^

# Coupling

![Coupling](assets/coupling.png)

Note:
* We can't avoid coupling. There's always going to be some degree of coupling between components.
* We aim for loosely coupled components, that talk to each other through well defined interfaces,
  and are easy to replace.

^

### Coupling through a property

```php
use Buzz\Browser;

class Crawler
{
    /**
     * @var Browser
     */
    private $browser;
}
```

^

### Coupling through a method call

```php
class Crawler
{
    private $c;

    public function crawl($url)
    {
        $this->c->getBrowser()->get($url);
    }
}

```

^

### Coupling through a reference

```php
use Buzz\Browser;

class Crawler
{
   public function crawl($url, Browser $b)
   {
       $response = $b->get($url);
   }
}
```

^

### Coupling through a reference

```php
use Buzz\Browser;

class Crawler
{
    /** 
     * @return Browser
     */
    public function crawl($url)
    {
        // ...
        
        return $browser;
    }
}
```

^

### Coupling through an implementation / extension

```php
use Buzz\Browser;

class Crawler extends Browser
{
    public function crawl($url)
    {
        $this->get($url);
    }
}
```

^

![](assets/crawler00.png)

Note:
* http://yuml.me/edit/912dbb3d

^

What if we implemented it this way?

```php
class PackageCrawler
{
    public function crawl()
    {
        $ch = curl_init(); 
        curl_setopt($ch, CURLOPT_URL, 'http://acme.com/'); 
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); 
        $response = curl_exec($ch); 
        curl_close($ch);  
        
        // @todo extract details from the response ...
    }
}
```

Note:
Low cohesion make a module:
* harder to understand
* harder to change
* harder to maintain
* harder to reuse

^

# Cohesion

> Cohesion describes how closely are elements in a module related

^

# Aim for

Loose coupling

High cohesion
