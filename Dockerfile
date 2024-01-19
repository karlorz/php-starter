# syntax=docker/dockerfile:labs
ARG COMPOSER_VERSION=2.6.5
ARG PHP_VERSION=8.2
ARG BOX_VERSION=4.5.1
ARG BOX_CHECKSUM=c24c400c424a68041d7af146c71943bf1acc0c5abafa45297c503b832b9c6b16

FROM php:${PHP_VERSION}-cli-alpine

# config system
RUN apk update \
    && apk add fish

# docker-php-ext-install intl json mbstring
# pas d'installations avec docker-php-ext-install, il faut gérer les dépendances systeme nous même.
# c'est pénible.
# On peut utiliser mlocati/docker-php-extension-installer qui simplifie ce travail
# (une seule commande, install des dépendances système ...)
# Liste des extensions disponibles : https://github.com/mlocati/docker-php-extension-installer#supported-php-extensions

# ajout des extensions
ADD --chmod=700 \
    https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
    /usr/local/bin/

# pour le runtime
RUN install-php-extensions intl json mbstring
# pour le dev
RUN install-php-extensions xdebug

RUN adduser -D -s /bin/fish -h /home/climber -u 1000 climber

# ajout composer
# on peut aussi installer composer avec `install-php-extensions @composer`
ARG COMPOSER_VERSION
ADD --chown=climber:climber \
    --chmod=744 \
    https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar \
    /usr/local/bin/composer
RUN composer --version

# ajout box
ARG BOX_VERSION
ARG BOX_CHECKSUM
ADD --chown=climber:climber \
    --chmod=744 \
    --checksum=sha256:${BOX_CHECKSUM} \
    https://github.com/box-project/box/releases/download/${BOX_VERSION}/box.phar \
    /usr/local/bin/box

# ajout jakzal/toolbox pour installer les autres outils
# ne fonctionne pas, sans donner d'explication -> bye bye
#ADD --chown=climber:climber \
#    --chmod=744 \
#    https://github.com/jakzal/toolbox/releases/latest/download/toolbox.phar \
#    /usr/local/bin/toolbox

# ajout phive
ADD --chown=climber:climber \
    --chmod=744 \
    https://github.com/phar-io/phive/releases/download/0.15.2/phive-0.15.2.phar \
    /usr/local/bin/phive


WORKDIR /app
RUN chown climber /app && mkdir -p /app/vendor/bin/

# ajout psysh
# @todo pas besoin des droits d'écriture, pour personne
ADD --chown=climber:climber \
    --chmod=744 \
    https://github.com/bobthecow/psysh/releases/download/v0.12.0/psysh-v0.12.0.tar.gz\
    /usr/local/bin/psysh

# ajout du dossier bin de composer au path pour executer directement les 
USER climber
RUN ["fish", "-c fish_add_path /app/vendor/bin"]

# installation d'une dépendance phive a ajouter dans ma cheatsheet.
# problème : si on a une nouvelle version, la clé n'est plus valide
#RUN ["phive", "install phpmd --trust-gpg-keys 9093F8B32E4815AA"]
# comme ça, on est lié à une version précise, plus de problème
#RUN ["phive", "install https://github.com/infection/infection/releases/download/0.27.8/infection.phar --trust-gpg-keys C5095986493B4AA0"]

# ajout d'une config pour tester.
# ici c'est juste le fichier, ça devient une config dans le compose.yml
#COPY dockerconfig /tmp/dockerconfig
# pas besoin de le copier, il est indiqué 'external'

# On pourrait avoir un entrypoint qui va faire l'ajout de psysh (voir au dessus).
CMD ["tail", "-f", "/dev/null"]

# appel php en cli avec xdebug
# XDEBUG_MODE=debug XDEBUG_SESSION=1 XDEBUG_CONFIG="client_host=172.17.0.1 client_port=9003" PHP_IDE_CONFIG="serverName=myrepl" php /app/hello.php
# il faut aussi faire un serveur dans phpstorm pour le mapping Config : PHP > Servers