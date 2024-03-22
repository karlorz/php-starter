# name of php docker container - get it using `docker ps`
container := "your-container-name"
docker_exec := "docker exec -it -u climber " + container
symfony := docker_exec + " symfony "
console := symfony + "console "

fish:
    docker exec -it -u climber {{container}} fish

serve:
    {{symfony}} server:start --no-tls --daemon

new-controller:
    {{console}} make:controller

new-api:
    {{console}} make:entity --api-resource
    {{console}} make:migration
    {{console}} doctrine:migrations:migrate

fixtures:
    {{console}} make:fixtures
    {{console}} doctrine:fixture:load
    # {{console}} doctrine:fixture:load --append