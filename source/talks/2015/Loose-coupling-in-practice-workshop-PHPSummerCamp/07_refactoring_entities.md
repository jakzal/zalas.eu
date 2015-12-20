# Entities

^

## Exercise 2.1

Move entities out of the bundle to its own namespace.

^

Convert the annotation mapping to xml.

```bash
app/console doctrine:mapping:convert xml \
    src/Infrastructure/Doctrine/Resources/config/AppBundle
```

Switch to the xml mapping.

```yaml
    orm:
        auto_generate_proxy_classes: "%kernel.debug%"
        auto_mapping: false
        mappings:
            AppBundle:
                type: xml
                is_bundle: false
                dir: %kernel.root_dir%/../src/Infrastructure/Doctrine/Resources/config/AppBundle
                prefix: AppBundle\Entity
                alias: AppBundle
            Blog:
                type: xml
                is_bundle: false
                dir: %kernel.root_dir%/../src/Infrastructure/Doctrine/Resources/config/Blog
                prefix: Blog
                alias: Blog
```

ORM annotations are no longer needed.

^

Move the `Post` and `Comment` entities to the `Blog` namespace.

Note:
grep -l -R 'AppBundle\\\\Entity\\\\Post' . | grep -v cache | grep -v logs | xargs sed -i -e 's/AppBundle\\\\Entity\\\\Post/Blog\\\\Post/g'
grep -l -R 'AppBundle\\\\Entity\\\\Comment' . | grep -v cache | grep -v logs | xargs sed -i -e 's/AppBundle\\\\Entity\\\\Comment/Blog\\\\Comment/g'

^

Introduce the `Blog\User` interface.

```php
namespace Blog;

interface User
{
    /**
     * @return string
     */
    public function getEmail();
}
```

The Blog classes can only depend on this interface, and not the `User` from the `AppBundle`.

^

### Checkpoint

```bash
app/console save
```

or:

```bash
git add -A
git commit -m 'Save progress'
git checkout workshop/2.1-entities
```

### Exercise diff

<small>https://github.com/jakzal/symfony-demo/compare/workshop/1.6-repository-methods...jakzal:workshop/2.1-entities</small>