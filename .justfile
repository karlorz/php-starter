set dotenv-load
docker_php_exec := "docker compose exec -it -u climber php"
symfony := docker_php_exec + " symfony "
composer := symfony + " composer "
console := symfony + "console "
docker_exec_nginx := "docker compose exec -it -u root nginx"
browser := "firefox"

up:
    docker compose up -d

# update source files + docker compose down+up
update: && tests
    git pull
    docker compose down
    docker compose up -d --build
    {{composer}} install

# open web browser
browser:
    {{browser}} http://localhost:$NGINX_PORT

# open a fish shell on the container
fish:
    {{docker_php_exec}} fish

[private]
fish_root:
    docker compose exec -it -u root php fish

new-controller:
    {{console}} make:controller

new-api:
    {{console}} make:entity --api-resource
    {{console}} make:migration
    {{console}} doctrine:migrations:migrate --no-interaction

# recréer une base de données
db-create:
    {{console}} doctrine:database:drop --quiet --no-interaction --if-exists --force
    {{console}} doctrine:database:create --quiet --no-interaction
    {{console}} doctrine:schema:create --quiet --no-interaction
    echo "Base de données recréée"

db-migrate:
    {{console}} doctrine:migrations:migrate --no-interaction

db-create-test:
    {{console}} doctrine:database:drop --env=test --force --if-exists
    {{console}} doctrine:database:create --env=test
    {{console}} doctrine:schema:create --env=test

# Create fixture class
db-fixtures-make entity:
    {{console}} make:fixtures {{entity}}Fixtures

# Insert fixture in database (env defined in .env)
db-fixtures-load:
    {{console}} doctrine:fixture:load --no-interaction

# Run command in Symfony console
console command:
    {{console}} {{command}}

# composer require package
req package:
    {{composer}} req {{package}}

# composer require package --dev
req-dev package:
    {{composer}} req {{package}} --dev

tests format='--testdox':
    {{docker_php_exec}} php bin/phpunit {{format}}

test filter:
    {{docker_php_exec}} php bin/phpunit --filter {{filter}}

# création d'un test
# The test type must be one of "TestCase", "KernelTestCase", "WebTestCase", "ApiTestCase", "PantherTestCase"
make-test name type='ApiTestCase':
    {{console}} make:test {{type}} {{name}}

# exécution d'une requête SQL
sql query env='dev':
    {{console}} dbal:run-sql "{{query}}" --env {{env}}

# interactive php shell
psysh:
    {{docker_php_exec}} psysh

[private]
[confirm("Écraser .git/hooks/pre-commit ?")]
install-pre-commit-hook:
    echo "docker compose exec php symfony composer run-script pre-commit" > .git/hooks/pre-commit
    {{docker_php_exec}} chmod +x .git/hooks/pre-commit

# firt run docker compose up + composer install + open browser
[private]
init:
    @echo press any key to review settings in .env
    @read
    @xdg-open .env
    just init-alt

[confirm("review/edit params in .env")]
[private]
init-alt:
    docker compose down
    just up
    {{composer}} install
    just db-create-test
    just db-create
    just browser