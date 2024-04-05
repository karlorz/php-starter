! This repository is at an early stage of development.
I use it to fast start my own projects/tests.  

---
# PHP / Docker / Composer Project Bedrock

Ready to use repository for any symfony project.
This provides a Docker image and files to bootstrap a Symfony project.

## Motivation

Avoid doing always the same things when starting a composer project.
Learn Docker, php server admin.

## Features

- based on php-fpm (alpine linux)
- xdebug, intl, pdo_pgsql
- composer
- fish shell
- symfony cli
- psysh


## Usage - Init

```shell
# create a new project
git clone https://github.com/SebSept/php-starter --depth 1
mv php-starter/ api/
cd api/
rm -rf .git
git init
git add .
git commit -m "Initial commit"

# check the port in docker-compose.yml # @todo use an override file or .env
# @todo maybe i should not specify the port in the docker-compose.yml file to let docker choose a free port
docker-compose up -d
# install composer dependencies
docker exec -it -u climber api_php_1 composer install
# start php dev server
docker exec -it -u climber api_php_1 symfony server:start --no-tls --daemon 
# access the app in browser
xdg-open http://localhost:8002 # change the port according to previous step
```

## Commands

Project has a .justfile (for [just task runner](https://github.com/casey/just) ) to help you with common tasks.

```shell
# run a fish shell in the php container
just fish
# start the php dev server
just serve
# create a new controller using maker bundle
just new-controller
# create a new api resource using maker bundle + create and run migration
just new-api

```




Outdated documentation : (just to remember)
This package replaces the following boring workflow (needs update) :
- Dev tools ready to run (phpunit, phpstan, php-cs-fixer)
- Composer scripts
- Git pre-commit hook installed.
- Dockerfile & dockercompose


```shell
mkdir my-new-project
cd my-new-project
phive install phpunit php-cs-fixer phpstan
vim phpstan.neon # go to phpstan website to find a phpstan.neon example
./tools/phpunit --generate-configuration # and answer questions
composer init
vim composer.json 
# fill name & description
# fill autoloading (find another file with psr-4 autoloading (since I tend to forget it))
# try a command line, write it in a composer script, for phpstan
# again for php-cs-fixer
# again for phpunit
git init
# add a git pre-commit hook that trigger composer dedicated script.
echo 'composer run-script pre-commit-hook' > .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit
# test and write the pre-commit-hook script for composer
edit .gitignore file
composer install
# done !
```

## Usage 

### Composer (recommended)

Instead of the boring previous commands, just do :

- `composer create-project sebsept/composer-starter:dev-dev my-new-project`
- `cd my-new-project`
- Edit composer.json to add name and description

Details inside the [composer.json](composer.json).

### GitHub

You can also the GitHub's button `template` (green on top right) to use this as starter point for your repo. [Détails](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template).

In this case, you'll have to create to link the pre-commit-hook yourself. (see inside [composer.json](composer.json) how it can be done.)

## Requirements

Linux / Mac / Wsl , [phive](https://phar.io/) and git installed.
