# Docker Learn D9

## Tools
- Docker
- Docker-compose
- PostgreSQL
- Composer
- Drush
- Drupal 9

## Installation

Voici un aperçu du dossier de l'environnement de travail.

### Contenu du dossier

```
├───config  *   *   *   *   *   *   Dossier des configurations des images docker
│   ├───dev *   *   *   *   *   *   Dossier pour l'environnement de developpement
│   │   ├───apache2
│   │   ├───php
│   │   └───env
│   └───prod    *   *   *   *   *   Dossier pour l'environnement de production
│       ├───apache2
│       ├───php
│       └───env
├───postgresql  *   *   *   *   *   Dossier de configuration PostgreSQL
│   └───gln_pg_initdb
└───var     *   *   *   *   *   *   Dossier Root du serveur web Apache
    └───html    *   *   *   *   *   Dossier Root de gestion de drupal avec Composer
        ├───config  *   *   *   *   Dossier des configurations Drupal
        │   ├───dev
        │   ├───preprod
        │   ├───prod
        │   ├───qa
        │   └───sync
        ├───features    *   *   *   Dossier des tests Behat
        ├───translations    *   *   Dossier des traductions Drupal
        └───web *   *   *   *   *   Dossier Root du site Drupal
            ├───libraries
            ├───modules
            │   └───custom
            ├───profiles
            ├───sites
            │   └───default
            │       └───files
            └───themes
                └───custom       
```


### Base de donnée
La base de donnée doit etre placée dans le dossier **postgresql/gln_pg_initdb**, pour être importée lors de la construction du container PostgreSQL.

```
├───postgresql
│   └───gln_pg_initdb        
```

### Variables
Avant de demarrer les containers, à la racine du projet Docker, veuillez copier le fichier `.env.default` en le renommant `.env`, puis remplacer les varibales selon votre convenance. 
Pour tester le projet, vous pouvez laisser les varibales par defaut.

```bash
# Pour le deploiement
ENV_ID=develop
# Drupal
DRUPAL_HOST=learn.mm
DRUPAL_TAG=1.0.0
DRUPAL_VERSION=9.3.8
DRUPAL_PORT=8076
DRUPAL_SITE_EMAIL=yeah@hello.mm
DRUPAL_SITE_NAME=Learn Drupal 9
# Drupal BO (Uniquement pour information, pour ne pas oublier :)
DRUPAL_SITE_ADMINISTRATOR=admin
DRUPAL_SITE_ADMINISTRATOR_PASS=admin
...
```

### Run container

À la racine du projet, lancer le docker compose.

```bash
docker compose up -d --build
```

La commande `docker ps` pour lister les containers.

```bash
docker ps

CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS          PORTS                           NAMES
763g543h90pe   learn/app/d9.3.8:1.0.1 "/opt/drupal/entrypo…"   33 minutes ago   Up 33 minutes   0.0.0.0:8076->80/tcp            learnapp
098erty65mpp   dpage/pgadmin4         "/entrypoint.sh"         33 minutes ago   Up 33 minutes   443/tcp, 0.0.0.0:5051->80/tcp   learnpgadmin
the6Ed4532oj   postgres               "docker-entrypoint.s…"   33 minutes ago   Up 33 minutes   0.0.0.0:5944->5432/tcp          learnpg
```

### Composer et les dépendances php de Drupal

#### Pour l'environnement de developpement

Lorsque vous aurez lancer vos containers, excécuter le container de l'application afin de télécharger les `dépendances php` de Drupal avec `composer`.

```bash
docker exec -it learnapp bash
```

Puis dans le container, à la racine du dossier `/opt/drupal`, j'execute `composer install`.

```bash
composer install
```

#### Pour l'environnement de production

Pour l'environnement de production, le `composer install` est lancé dans le script du `Dockerfile`

```bash
# Install composer stuff
RUN composer install --no-dev
```

### Build de l'image pour un contexte de production

Pour le build de l'image et le deployement du container :

- Je me place à la racine du projet et je lance la commande suivante.

```bash
docker build -f ./config/production/Dockerfile -t learn/app/d9.3.8:1.0.1 --no-cache .
```

#### Description de la commande

- On indique à Docker quel fichier Dockerfile utiliser
```
-f ./config/production/Dockerfile 
```
- Puis le nom et le tags de l'image
```
-t learn/app/d9.3.8:1.0.1
```
- On demande à docker de na pas utiliser les caches
```
--no-cache
```
- On indique l'emplacement racine des fichiers a ajouter dans l'images.
```
.
```
