# Crawler Exercise

Create a console command that will crawl the recent blog articles page
[http://127.0.0.1:8000/en/blog/](http://127.0.0.1:8000/en/blog/)
and will list their titles and URLs.

^

Before you start, consider how you'd approach the task in several scenarios:
* You're only building a prototype.
* This is not a typical task on your project
  and this is probably the only crawler you'll ever need to build.
* There's several crawlers planned on this project to be built
  at some time in future.

Note:
* What if you thought there's only gonna be a single crawler,
  but after some time there's a need for another one?

^

## Exercise 1.1

Implement the `Crawler\Article` class.

It is already described in tests (currently skiped):

    ./bin/phpunit -c app tests/Crawler/ArticleTest.php

^

### Checkpoint

```bash
app/console save
```

or:

```bash
git add -A
git commit -m 'Save progress'
git checkout exercise/crawler/1.2-article-list-crawler
```

^

## Exercise 1.2

Implement the `Crawler\ArticleListCrawler` class by making tests pass one at a time:

    ./bin/phpunit -c app tests/Crawler/ArticleListCrawlerTest.php

**Hint**: You'll need to create two interfaces which are `Crawler\ArticleListCrawler`'s
collaborators:
* `Crawler\ContentProvider`
* `Crawler\ArticleExtractor`

Check the tests for methods that need to be defined on these interfaces.

^

### Checkpoint

```bash
app/console save
```

or:

```bash
git add -A
git commit -m 'Save progress'
git checkout exercise/crawler/1.3-article-extractor
```

^

## Exercise 1.3

Change the `Crawler\ArticleExtractor` interface to a class and implement it.
Make all its tests pass one by one:

    ./bin/phpunit -c app tests/Crawler/ArticleExtractorTest.php

**Hint**: Use `preg_match_all()` with the `Crawler\ArticleExtractor::ARTICLE_REGEXP`
constant to find articles in content.

^

### Checkpoint

```bash
app/console save
```

or:

```bash
git add -A
git commit -m 'Save progress'
git checkout exercise/crawler/1.4-file-get-contents-content-provider
```

^

## Exercise 1.4

Create an implementation of the `Crawler\ContentProvider` interface
based on `file_get_contents()`. The test is already written for you:

    ./bin/phpunit -c app tests/Crawler/ContentProvider/FileGetContentsContentProviderTest.php

This is the first integration test we'll implement. As opposed
to unit tests, we don't mock collaborators in an integration test,
as we actually want to verify if our class plays nicely with
infrastructure or third party libraries.

^

### Checkpoint

```bash
app/console save
```

or:

```bash
git add -A
git commit -m 'Save progress'
git checkout exercise/crawler/1.5-article-list-crawler-factory
```

^

## Exercise 1.5

Create a factory for the `Crawler\ArticleListCrawler`:

    ./bin/phpunit -c app tests/CrawlerBundle/Crawler/ArticleListCrawlerFactoryTest.php

We'll use it later in the command to create the crawler, so
the creation is not handled in the command itself.
We could also use a service container to achieve the same.
Basic idea is to separate creation of a service from its use.

^

### Checkpoint

```bash
app/console save
```

or:

```bash
git add -A
git commit -m 'Save progress'
git checkout exercise/crawler/1.6-article-list-command
```

^

## Exercise 1.6

Finally, implement the console command:

    ./bin/phpunit -c app tests/CrawlerBundle/Command/ArticleListCommandTest.php

Make sure to define a `--resource` option.
It should be possible to execute the command like this:

    app/console article:list --resource=http://127.0.0.1:8000/en/blog/

^

### Checkpoint

```bash
app/console save
```

or:

```bash
git add -A
git commit -m 'Save progress'
git checkout exercise/crawler/1.7-guzzle-content-provider
```

^

## Exercise 1.7

Provide a Guzzle implementation of the `Crawler\ContentProvider`.
Include an integration test for bonus points.

Remember to handle errors (guzzle exceptions) and to use
the new provider in a factory instead of the old one.

^

### Checkpoint

```bash
app/console save
```

or:

```bash
git add -A
git commit -m 'Save progress'
git checkout exercise/crawler/1.8-solutions
```
