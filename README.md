# Composer Project Bedrock

Ready to use repository for any composer project.

- Dev tools ready to run (phpunit, phpstan, php-cs-fixer)
- Composer scripts
- Git pre-commit hook installed.

## Motivation

Avoid doing always the same things when starting a composer project.

This package replaces the following boring workflow :

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

Instead of the boring previous commands, just do :

- `composer create-project sebsept/composer-starter:dev-main my-new-project`
- `cd my-new-project`
- edit composer.json to add name and description

Details inside the [composer.json](composer.json).

## Requirements

Linux / Mac / Wsl , [phive](https://phar.io/) and git installed.
