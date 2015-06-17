# The Dependency Inversion Principle

^

### High-level modules should not depend on low-level modules. 

```php
use Buzz\Browser;

class PackageCrawler
{
    private $browser;
    
    public function __construct(Browser $browser)
    {
        $this->browser = $browser;
    }
    
    public function crawl($resource)
    {
        $response = $this->browser->get($resource);
        
        // ...
    }
}
```

^

### High-level modules should not depend on low-level modules. 

![Crawler](assets/crawler01.png)

^

### Both should depend on abstractions. 

![Crawler](assets/crawler04.png)

Note:
http://yuml.me/edit/f81d34fe

^

### Both should depend on abstractions. 

```php
interface HttpClient
{
    public function get($resource);
}
```

^

### Both should depend on abstractions. 

```php
class PackageCrawler
{
   private $httpClient;

   public function __construct(HttpClient $httpClient)
   {
       $this->httpClient = $httpClient;
   }

   public function crawl()
   {
       $response = $this->httpClient->get('/');

       // @todo parse
   }
}
```

^

### Both should depend on abstractions. 

![Crawler](assets/crawler06.png)

Note:
http://yuml.me/edit/f81d34fe
http://yuml.me/edit/9158c45e

^

### Both should depend on abstractions. 

```php
use Buzz\Browser;

class BuzzHttpClient implements HttpClient
{
    private $browser;

    public function __construct(Browser $browser)
    {
        $this->browser = $browser;
    }

    public function get($resource)
    {
        return (string) $this->browser->get($resource);
    }
}
```

^

### Abstractions should not depend upon details.

![Crawler](assets/crawler06.png)

^

### Details should depend upon abstractions.

![Crawler](assets/crawler09.png)

Note:
http://yuml.me/edit/3dacc9bd
http://yuml.me/edit/567ea1d7

^

```php
interface ContentProvider
{
    public function fetch($resource);
}
```

^

```php
class PackageCrawler
{
   private $contentProvider;

   public function __construct(ContentProvider $provider)
   {
       $this->contentProvider = $provider;
   }

   public function crawl()
   {
       $content = $this->contentProvider->fetch('/');

       // @todo parse
   }
}
```

^

```php
use Buzz\Browser;

class BuzzContentProvider implements ContentProvider
{
    private $browser;

    public function __construct(Browser $browser)
    {
        $this->browser = $browser;
    }

    public function fetch()
    {
        return (string) $this->browser->get('/');
    }
}
```

^

![Crawler](assets/crawler10.png)

Note:
http://yuml.me/edit/8cede4c8

^

![Crawler](assets/crawler13.png)

Note:
http://yuml.me/edit/0aa9dc28
http://yuml.me/edit/35376872

^

```php
use Guzzle\Client;

class GuzzleContentProvider implements ContentProvider
{
    private $guzzle;

    public function __construct(Client $guzzle)
    {
        $this->guzzle = $guzzle;
    }

    public function fetch($resource)
    {
        $request = $this->guzzle->createRequest(
            'GET', $resource
        );
        $response = $request->send();

        return $response->getBody();
    }
}
```

^

![Crawler](assets/crawler16.png)

Note:
http://yuml.me/edit/0581c71e

^

What about the framework?

```php
class ProductController extends Controller
{
    public function searchAction($keywords)
    {
        $products = $this->get('doctrine')
            ->getRepository('Acme:Product');
            ->search($keywords);
        
        return $this->render(
            'product/search.html.twig',
            ['products' => $products]
        );
    }
}
```

^

![Conroller](assets/controller01.png)

Note:
http://yuml.me/edit/146994a7

^

```php
interface ProductRepository
{
    /**
     * @return Product[]
     */
    public function search($keywords);
}
```

^

```php
class DoctrineProductRepository implements ProductRepository
{
    private $em;
    
    public function __construct(EntityManager $em)
    {
        $this->em = $em;
    }
    
    /**
     * @return Product[]
     */
    public function search($keywords)
    {
        return $this->em->createQueryBuilder()
            ->select('p')
            ->from(Product::class, 'p')
            ->where('p.title LIKE :keywords')
            ->setParameter('keywords', '%'.$keywords.'%')
            ->getQuery()
            ->getResult();
    }
}
```

^

```php
class ProductController
{
    private $productRepository;
    private $templating;
    
    public function __construct(
        ProductRepository $productRepository,
        EngineInterface $templating
    ) {
        $this->productRepository = $productRepository;
        $this->templating = $templating;
    }
    
    // ...
}
```

^

```php
class ProductController
{
    // ...
    
    public function searchAction($keywords)
    {
        $products = $this->productRepository->search($keywords);
        
        return $this->templating->renderResponse(
            'product/search.html.twig',
            ['products' => $products]
        );
    }
}
```

^

![Controller](assets/controller03a.png)

Note:
http://yuml.me/edit/ee387719

^

![Controller](assets/controller04.png)

Note:
http://yuml.me/edit/ee387719
http://yuml.me/edit/4e86422b

^

![Controller](assets/controller05.png)

^

![Good code](assets/good_code.png "Good code")

Note:
Image credits: https://xkcd.com/844/

^

> **Good code** doesn't take more time to write. 

> What takes a lot of time is **the learning** how to write good code.

