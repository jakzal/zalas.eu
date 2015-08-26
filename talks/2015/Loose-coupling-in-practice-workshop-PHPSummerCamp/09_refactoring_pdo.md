# PDO

an alternative implementation

^

## Exercise 4.1

Register aliases for repositories to enable alternative implementations.

^

`app/config/services.yml`

```yaml
    # ...
    post_repository.doctrine:
        class:     Blog\PostRepository
        factory:   ["@doctrine.orm.entity_manager", getRepository]
        arguments: [Blog\Post]

    comment_repository.doctrine:
        class:     Blog\CommentRepository
        factory:   ["@doctrine.orm.entity_manager", getRepository]
        arguments: [Blog\Comment]

    user_repository.doctrine:
        class:     AppBundle\Entity\UserRepository
        factory:   ["@doctrine.orm.entity_manager", getRepository]
        arguments: [AppBundle\Entity\User]

    post_repository: @post_repository.doctrine
    comment_repository: @comment_repository.doctrine
    user_repository: @user_repository.doctrine
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
git checkout workshop/4.1-repository-aliases
```

### Exercise diff

<small>https://github.com/jakzal/symfony-demo/compare/workshop/3.3-repositories-in-infrastructure...jakzal:workshop/4.1-repository-aliases</small>

^

## Exercise 4.2

Create a PDO implementation of repositories.

^

### Checkpoint

```bash
app/console save
```

or:

```bash
git add -A
git commit -m 'Save progress'
git checkout workshop/4.2-pdo-implementation
```

### Exercise diff

<small>https://github.com/jakzal/symfony-demo/compare/workshop/4.1-repository-aliases...jakzal:workshop/4.2-pdo-implementation</small>

^

## Exercise 4.3

Switch to the PDO implementation of repositories.
^

`app/config/services.yml`

```yaml
    # ...

    post_repository: @post_repository.pdo
    comment_repository: @comment_repository.pdo
    user_repository: @user_repository.pdo
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
git checkout workshop/4.3-enable-pdo
```

### Exercise diff

<small>https://github.com/jakzal/symfony-demo/compare/workshop/4.2-pdo-implementation...jakzal:workshop/4.3-enable-pdo</small>