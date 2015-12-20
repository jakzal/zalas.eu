# Repository interfaces

^

## Exercise 3.1

Introduce repository interfaces.

^

`loose/src/Blog/PostRepository.php`

```php
namespace Blog;

interface PostRepository
{
    /**
     * @param int $limit
     *
     * @return Post[]
     */
    public function findLatest($limit = Post::NUM_ITEMS);

    /**
     * @param int $id
     *
     * @return null|Post
     */
    public function findOneById($id);
    
    // ...
}
```

^

`src/Blog/PostRepository.php`

```php
namespace Blog;

interface PostRepository
{
    // ...
    
    /**
     * @param $slug
     *
     * @return null|Post
     */
    public function findOneBySlug($slug);

    /**
     * @param Post $post
     */
    public function publish(Post $post);

    /**
     * @param Post $post
     */
    public function remove(Post $post);
}
```

^

`src/Blog/CommentRepository.php`

```php
namespace Blog;

interface CommentRepository
{
    /**
     * @param Comment $comment
     */
    public function post(Comment $comment);
}
```

^

`src/AppBundle/Entity/UserRepository.php`

```php
namespace AppBundle\Entity;

interface UserRepository
{
    /**
     * @param string $username
     *
     * @return null|User
     */
    public function findOneByUsername($username);

    /**
     * @param int $maxResults
     *
     * @return User[]
     */
    public function findSorted($maxResults);

    /**
     * @param User $user
     */
    public function register(User $user);
}
```

^

### Checkpoint

```bash
app/console save
```

or:

```bash
git add -A
git commit -m 'Save progress'
git checkout workshop/3.1-repository-interfaces
```

### Exercise diff

<small>https://github.com/jakzal/symfony-demo/compare/workshop/2.1-entities...jakzal:workshop/3.1-repository-interfaces</small>

^

## Exercise 3.2

Configure repository services to return interfaces.

^

```yaml
services:
    # ...

    post_repository:
        class:     Blog\PostRepository
        factory:   ["@doctrine.orm.entity_manager", getRepository]
        arguments: [Blog\Post]

    comment_repository:
        class:     Blog\CommentRepository
        factory:   ["@doctrine.orm.entity_manager", getRepository]
        arguments: [Blog\Comment]

    user_repository:
        class:     AppBundle\Entity\UserRepository
        factory:   ["@doctrine.orm.entity_manager", getRepository]
        arguments: [AppBundle\Entity\User]
```

^

### Checkpoint

```bash
app/console save
```

or:

```bash
git add -A
git commit -m 'Save progress'
git checkout workshop/3.2-repository-type-hints
```

### Exercise diff

<small>https://github.com/jakzal/symfony-demo/compare/workshop/3.1-repository-interfaces...jakzal:workshop/3.2-repository-type-hints</small>

^

## Exercise 3.3

Move repository implementations into the `Infrastructure` namespace.

^

`src/Infrastructure/Doctrine/Resources/config/Blog/Post.orm.xml`

```xml
<entity 
 repository-class="Infrastructure\Doctrine\Repository\PostRepository" 
 name="Blog\Post" 
 table="Post">
```

^

`src/Infrastructure/Doctrine/Resources/config/Blog/Comment.orm.xml`

```xml
<entity
 repository-class="Infrastructure\Doctrine\Repository\CommentRepository" 
 name="Blog\Comment" 
 table="Comment">
```

^

`src/Infrastructure/Doctrine/Resources/config/AppBundle/User.orm.xml`

```xml
<entity
 repository-class="Infrastructure\Doctrine\Repository\UserRepository"
 name="AppBundle\Entity\User"
 table="User">
```

^

### Checkpoint

```bash
app/console save
```

or:

```bash
git add -A
git commit -m 'Save progress'
git checkout workshop/3.3-repositories-in-infrastructure
```

### Exercise diff

<small>https://github.com/jakzal/symfony-demo/compare/workshop/3.2-repository-type-hints...jakzal:workshop/3.3-repositories-in-infrastructure</small>