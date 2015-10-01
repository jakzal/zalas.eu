<!-- .slide: data-background="assets/phpnw-crowd.png" -->
<!-- .element: id="title-slide" -->

# Loose coupling in practice

<img class="logo" src="assets/phpnw15-white.png" alt="PHP North West 2015" />

*2nd October 2015*

<div class="social">
    <div>Jakub Zalas</div>
    <span class="twitter">[@jakub_zalas](https://twitter.com/jakub_zalas)</span>
    <span class="github">[@jakzal](https://github.com/jakzal)</span>
</div>

^

## Before we start

Step 0: Clone the repo (should've been done already):

```bash
git clone git@github.com:jakzal/phpnw15-workshop.git
cd phpnw15-workshop
```

Step 1: Pull the latest version and run the setup script:

```bash
git pull
php setup.php
```

Step 2: Run the tests:

```bash
php bin/phpunit -c app
```

Step 3: Start the web server

```bash
php app/console server:run
```
