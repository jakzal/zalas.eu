<!-- .slide: data-background="assets/rovinj.jpg" -->
<!-- .element: id="title-slide" -->

# Loose coupling in practice

<img class="logo" src="assets/phpsummercamp.svg" alt="PHP Summer Camp 2015" />

*27th August 2015*

<div class="social">
    <div>Jakub Zalas</div>
    <span class="twitter">[@jakub_zalas](https://twitter.com/jakub_zalas)</span>
    <span class="github">[@jakzal](https://github.com/jakzal)</span>
</div>

^

## Before we start

Step 1: Start your [VM](https://github.com/netgen/summercamp-2015)s

```bash
vagrant up --no-provision
```

Step 2: Update the workshop

```bash
vagrant ssh
cd /var/www/summercamp
./run.sh loose
```

Step 3: Confirm everything's fine

```bash
cd workshops/loose
./bin/phpunit -c app
```

^

## Before we start

Step 4: Configure git

```bash
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

Step 5: Visit http://loose.phpsc/
