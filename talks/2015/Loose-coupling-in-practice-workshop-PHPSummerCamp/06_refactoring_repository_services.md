# Repository as a service

^

## Exercise 1.1
 
Register services for the post, user and comment repositories.

^

`app/config/services.yml`

```yaml
services:
    # ...

    post_repository:
        class:     AppBundle\Repository\PostRepository
        factory:   ["@doctrine.orm.entity_manager", getRepository]
        arguments: [AppBundle\Entity\Post]

    comment_repository:
        class:     AppBundle\Repository\CommentRepository
        factory:   ["@doctrine.orm.entity_manager", getRepository]
        arguments: [AppBundle\Entity\Comment]

    user_repository:
        class:     AppBundle\Repository\UserRepository
        factory:   ["@doctrine.orm.entity_manager", getRepository]
        arguments: [AppBundle\Entity\User]
```

^

`src/AppBundle/Repository/CommentRepository.php`

```php
namespace AppBundle\Repository;

use Doctrine\ORM\EntityRepository;

class CommentRepository extends EntityRepository
{
}
```

^

`src/AppBundle/Entity/Comment.php`

```php
namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * @ORM\Entity(
 *     repositoryClass="AppBundle\Repository\CommentRepository"
 * )
 */
class Comment
{
    // ...
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
git checkout workshop/1.1-repository-services
```

^

## Exercise 1.2

Refactor all the controllers and commands to retrieve repositories from
the service container rather than the entity manager.

### Hint

Find all occurences of `getRepository` in `src`.

* Bash: `grep -R getRepository src/`
* PhpStorm: `CMD+SHIFT+F` -> find "getRepository"

^

`src/AppBundle/Controller/BlogController.php`

```php
/**
 * @Route("/blog")
 */
class BlogController extends Controller
{
    /**
     * @Route("/", name="blog_index")
     */
    public function indexAction()
    {
        $posts = $this->get('post_repository')->findLatest();

        return $this->render(
            'blog/index.html.twig', ['posts' => $posts]
        );
    }
    
    // ...
}
```

^

`src/AppBundle/Controller/Admin/BlogController.php`

```php
/**
 * @Route("/admin/post")
 * @Security("has_role('ROLE_ADMIN')")
 */
class BlogController extends Controller
{
    /**
     * @Route("/", name="admin_index")
     * @Route("/", name="admin_post_index")
     * @Method("GET")
     */
    public function indexAction()
    {
        $posts = $this->get('post_repository')->findAll();

        return $this->render(
            'admin/blog/index.html.twig', ['posts' => $posts]
        );
    }
    
    // ...
}
```
^

`src/AppBundle/Command/AddUserCommand.php`

```php
class AddUserCommand extends ContainerAwareCommand
{
    /**
     * @var UserRepository
     */
    private $userRepository;
    
    // ...
    
    protected function initialize(
        InputInterface $input, OutputInterface $output
    ) {
        $this->em = $this->getContainer()
            ->get('doctrine')->getManager();
            
        $this->userRepository = $this->getContainer()
            ->get('user_repository');
    }

    // ...
}
```

^

`src/AppBundle/Command/AddUserCommand.php`

```php
class AddUserCommand extends ContainerAwareCommand
{
    // ...

    protected function execute(
        InputInterface $input, OutputInterface $output
    ) {
        // ...

        // first check if a user with the same username already exists
        $existingUser = $this->userRepository
            ->findOneBy(array('username' => $username));
        
        // ...
    }
    
    // ...
}
```

^

`src/AppBundle/Command/ListUsersCommand.php`

```php
class ListUsersCommand extends ContainerAwareCommand
{
    /**
     * @var UserRepository
     */
    private $userRepository;
    
    // ...
 
    protected function initialize(
        InputInterface $input, OutputInterface $output
    ) {
        $this->userRepository = $this->getContainer()
            ->get('user_repository');
    }
    
    // ...
}
```

^

`src/AppBundle/Command/ListUsersCommand.php`

```php
class ListUsersCommand extends ContainerAwareCommand
{
    protected function execute(
        InputInterface $input, OutputInterface $output
    ) {
        $maxResults = $input->getOption('max-results');
        // Use ->findBy() instead of ->findAll() to allow result sorting and limiting
        $users = $this->userRepository
            ->findBy([], ['id' => 'DESC'], $maxResults);
    }
    
    // ...
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
git checkout workshop/1.2-repository-query-methods
```

^

## Exercise 1.3

Push all the remaining database related operations to the repositories,
so there's no entity manager used outside of them.

^

`src/AppBundle/Controller/BlogController.php`

```php
public function commentNewAction(Request $request, Post $post)
{
    $form = $this->createCommentForm();

    $form->handleRequest($request);

    if ($form->isSubmitted() && $form->isValid()) {
        $comment = $form->getData();
        $comment->setAuthorEmail($this->getUser()->getEmail());
        $comment->setPost($post);

        $this->get('comment_repository')->post($comment);
        // ...
    }
    // ...
}         
```

^

`src/AppBundle/Repository/CommentRepository.php`

```php
/**
 * @param Comment $comment
 */
public function post(Comment $comment)
{
    $em = $this->getEntityManager();
    $em->persist($comment);
    $em->flush();
}
```

^

`src/AppBundle/Controller/Admin/BlogController.php`

```php
public function newAction(Request $request)
{
    // ...
    
    if ($form->isSubmitted() && $form->isValid()) {
        $post->setSlug($this->get('slugger')
            ->slugify($post->getTitle()));

        $this->get('post_repository')->publish($post);

        return $this->redirectToRoute('admin_post_index');
    }

    // ...
}
```

^

`src/AppBundle/Repository/PostRepository.php`

```php
/**
 * @param Post $post
 */
public function publish(Post $post)
{
    $em = $this->getEntityManager();
    $em->persist($post);
    $em->flush();
}
```

^

`src/AppBundle/Controller/Admin/BlogController.php`

```php
public function editAction(Post $post, Request $request)
{
    // ...
    
    if ($editForm->isSubmitted() && $editForm->isValid()) {
        $post->setSlug($this->get('slugger')
            ->slugify($post->getTitle()));
        
        $this->get('post_repository')->publish($post);

        return $this->redirectToRoute(
            'admin_post_edit', ['id' => $post->getId()]
        );
    }
}
```

^

`src/AppBundle/Controller/Admin/BlogController.php`

```php
public function deleteAction(Request $request, Post $post)
{
    $form = $this->createDeleteForm($post);
    $form->handleRequest($request);

    if ($form->isSubmitted() && $form->isValid()) {
        $this->get('post_repository')->remove($post);
    }

    return $this->redirectToRoute('admin_post_index');
}
```

^

`src/AppBundle/Repository/PostRepository.php`

```php
/**
 * @param Post $post
 */
public function remove(Post $post)
{
    $em = $this->getEntityManager();
    $em->remove($post);
    $em->flush();
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
git checkout workshop/1.3-repository-update-methods
```

^

### Question

What happens when no param converter annotation is configured in the following example?

```php
/**
 * @Route("/posts/{slug}", name="blog_post")
 */
public function postShowAction(Post $post)
{
    return $this->render(
        'blog/post_show.html.twig', ['post' => $post]
    );
}
```

Note:
* What are the issues with this approach?
 * performance
 * magic


^

## Exercise 1.4

Explicitly configure the service param converter.

* use the [zalas/param-converter-bundle](https://github.com/jakzal/ParamConverterBundle)
  which is already enabled in the project.
* Example:

```php
/**
 * @ParamConverter("post", converter="service", options={
 *     "service"="post_repository", 
 *     "method"="findOneBySlug", 
 *     "arguments":{"slug"}
 * })
 */
```

^

`src/AppBundle/Controller/BlogController.php`

```php
/**
 * @Route("/posts/{slug}", name="blog_post")
 *
 * @ParamConverter("post", converter="service", options={
 *     "service"="post_repository",
 *     "method"="findOneBySlug",
 *     "arguments":{"slug"}
 * })
 */
public function postShowAction(Post $post) { /* ... */ }
```

^

`src/AppBundle/Controller/BlogController.php`

```php
/**
 * @Route("/comment/{postSlug}/new", name = "comment_new")
 * @Security("is_granted('IS_AUTHENTICATED_FULLY')")
 *
 * @Method("POST")
 * @ParamConverter("post", converter="service", options={
 *     "service"="post_repository",
 *     "method"="findOneBySlug",
 *     "arguments":{"postSlug"}
 * })
 */
public function commentNewAction(Request $request, Post $post) { /* ... */ }
```

^

`src/AppBundle/Controller/BlogController.php`

```php
/**
 * @ParamConverter("post", converter="service", options={
 *     "service"="post_repository",
 *     "method"="findOneById",
 *     "arguments":{"id"}
 * })
 */
public function commentFormAction(Post $post) { /* ... */ }
```

^

`src/AppBundle/Controller/Admin/BlogController.php`

```php
/**
 * @Route("/{id}", requirements={"id" = "\d+"}, name="admin_post_show")
 * @Method("GET")
 * @ParamConverter("post", converter="service", options={
 *     "service"="post_repository",
 *     "method"="findOneById",
 *     "arguments":{"id"}
 * })
 */
public function showAction(Post $post) { /* ... */ }
```

^

`src/AppBundle/Controller/Admin/BlogController.php`

```php
/**
 * @Route("/{id}/edit", requirements={"id" = "\d+"}, name="admin_post_edit")
 * @Method({"GET", "POST"})
 * @ParamConverter("post", converter="service", options={
 *     "service"="post_repository",
 *     "method"="findOneById",
 *     "arguments":{"id"}
 * })
 */
public function editAction(Post $post, Request $request) { /* ... */ }
```

^

`src/AppBundle/Controller/Admin/BlogController.php`

```php
/**
 * @Route("/{id}", name="admin_post_delete")
 * @Method("DELETE")
 * @Security("post.isAuthor(user)")
 * @ParamConverter("post", converter="service", options={
 *     "service"="post_repository",
 *     "method"="findOneById",
 *     "arguments":{"id"}
 * })
 */
public function deleteAction(Request $request, Post $post) { /* ... */ }
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
git checkout workshop/1.4-service-param-converter
```

^

## Exercise 1.5

Register a custom user provider that leverages the user repository.

^

`src/AppBundle/Security/User/UserProvider.php`

```php
namespace AppBundle\Security\User;

use AppBundle\Entity\User;
use AppBundle\Entity\UserRepository;
use Symfony\Component\Security\Core\Exception\UnsupportedUserException;
use Symfony\Component\Security\Core\Exception\UsernameNotFoundException;
use Symfony\Component\Security\Core\User\UserInterface;
use Symfony\Component\Security\Core\User\UserProviderInterface;

class UserProvider implements UserProviderInterface
{
    /**
     * @var UserRepository
     */
    private $userRepository;

    /**
     * @param UserRepository $userRepository
     */
    public function __construct(UserRepository $userRepository)
    {
        $this->userRepository = $userRepository;
    }    
    // ...
}
```

^

`src/AppBundle/Security/User/UserProvider.php`

```php
class UserProvider implements UserProviderInterface
{
    // ...

    /**
     * @param string $username
     *
     * @return UserInterface
     */
    public function loadUserByUsername($username)
    {
        $user = $this->userRepository->findOneByUsername($username);

        if (null === $user) {
            throw new UsernameNotFoundException(
                sprintf('User "%s" not found.', $username)
            );
        }

        return $user;
    }
    
    // ...
```

^

`src/AppBundle/Security/User/UserProvider.php`

```php
class UserProvider implements UserProviderInterface
{
    // ...

    /**
     * @param UserInterface $user
     *
     * @return UserInterface
     */
    public function refreshUser(UserInterface $user)
    {
        if (!$user instanceof User) {
            throw new UnsupportedUserException(
                sprintf('Instances of "%s" are not supported.', get_class($user))
            );
        }

        return $this->loadUserByUsername($user->getUsername());
    }
    
    // ...
```

^

`src/AppBundle/Security/User/UserProvider.php`

```php
class UserProvider implements UserProviderInterface
{
    // ...

    /**
     * @param string $class
     *
     * @return bool
     */
    public function supportsClass($class)
    {
        return $class === User::class;
    }
}
```

^

`app/config/services.yml`

```yaml

services:
    # ...
    user_provider:
        class: AppBundle\Security\User\UserProvider
        arguments:
            - @user_repository
```

^

`app/config/security.yml`

```yaml

security:
   # ...
   providers:
        users:
            id: user_provider
            
   # ...
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
git checkout workshop/1.5-user-provider
```

^

### Question

Where can I see how we query for blog posts?

^

Where does the `findAll()` method come from?

```php
namespace AppBundle\Controller\Admin;

class BlogController extends Controller
{
    public function indexAction()
    {
        $posts = $this->get('post_repository')->findAll();

        return $this->render(
            'admin/blog/index.html.twig', ['posts' => $posts]
        );
    }
}
```

^

## Exercise 1.6

Replace all the magic and doctrine's default methods with
explicit repository methods.

^

`src/AppBundle/Repository/PostRepository.php`

```php
/**
 * @return Post[]
 */
public function findAll()
{
    return parent::findAll();
}

/**
 * @param int $id
 * @return null|Post
 */
public function findOneById($id)
{
    return $this->find($id);
}

/**
 * @param string $slug
 * @return null|Post
 */
public function findOneBySlug($slug)
{
    return $this->findOneBy(['slug' => $slug]);
}
```

^

`src/AppBundle/Repository/UserRepository.php`

```php
/**
 * @param string $username
 *
 * @return null|User
 */
public function findOneByUsername($username)
{
    return $this->findOneBy(['username' => $username]);
}

/**
 * @param int $maxResults
 *
 * @return User[]
 */
public function findSorted($maxResults)
{
    return $this->findBy([], ['id' => 'DESC'], $maxResults);
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
git checkout workshop/1.6-repository-methods
```
