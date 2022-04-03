# Docker Learn D9

## Tools

- Docker
- Docker-compose
- PostgreSQL
- Composer
- Drush
- Drupal 9

## Installation

Here is an overview of the working environment folder

### File contents

```
├───config  *   *   *   *   *   *   Docker images configurations folder
│   ├───dev *   *   *   *   *   *   Folder for the development environment
│   │   ├───apache2
│   │   ├───php
│   │   └───env
│   └───prod    *   *   *   *   *   Folder for production environment
│       ├───apache2
│       ├───php
│       └───env
├───postgresql  *   *   *   *   *   PostgreSQL configuration folder
│   └───gln_pg_initdb
└───var     *   *   *   *   *   *   Root folder of the Apache web server
    └───html    *   *   *   *   *   Drupal Management Root Folder with Composer
        ├───config  *   *   *   *   Drupal configurations folder
        │   ├───dev
        │   ├───preprod
        │   ├───prod
        │   ├───qa
        │   └───sync
        ├───features    *   *   *   Behat Test Folder
        ├───translations    *   *   Drupal translations folder
        └───web *   *   *   *   *   Drupal Site Root Folder
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


### Database
The database must be placed in the **postgresql/gln_pg_initdb** folder, to be imported during the construction of the PostgreSQL container.

```
├───postgresql
│   └───gln_pg_initdb        
```

### Variables
Before starting the containers, at the root of the Docker project, please copy the `.env.default` file, renaming it `.env`, then replace the varibales as you wish.
To test the project, you can leave the default variables.

```bash
# For deploy
ENV_ID=develop
# Drupal
DRUPAL_HOST=learn.mm
DRUPAL_TAG=1.0.0
DRUPAL_VERSION=9.3.8
DRUPAL_PORT=8076
DRUPAL_SITE_EMAIL=yeah@hello.mm
DRUPAL_SITE_NAME=Learn Drupal 9
# Drupal BO (For information only, so as not to forget :)
DRUPAL_SITE_ADMINISTRATOR=admin
DRUPAL_SITE_ADMINISTRATOR_PASS=admin

...
```

### Run container

- At the root of the project, launch the docker compose.

```bash
docker compose up -d --build
```

- The `docker ps` command to list containers.

```bash
docker ps

CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS          PORTS                           NAMES
763g543h90pe   learn/app/d9.3.8:1.0.1 "/opt/drupal/entrypo…"   33 minutes ago   Up 33 minutes   0.0.0.0:8076->80/tcp            learnapp
098erty65mpp   dpage/pgadmin4         "/entrypoint.sh"         33 minutes ago   Up 33 minutes   443/tcp, 0.0.0.0:5051->80/tcp   learnpgadmin
the6Ed4532oj   postgres               "docker-entrypoint.s…"   33 minutes ago   Up 33 minutes   0.0.0.0:5944->5432/tcp          learnpg
```

### Composer and Drupal php dependencies

#### For development environment

When you have launched your containers, execute the container of the application in order to download the `php dependencies` of Drupal with `composer`.

```bash
docker exec -it learnapp bash
```

Then in the container, at the root of the `/opt/drupal` folder, I run `composer install`.

```bash
composer install
```

#### For the production environment

For the production environment, the `composer install` is launched in the `Dockerfile` script

```bash
# Install composer stuff
RUN composer install --no-dev
```

### Build the image for a production context

For the build of the image and the deployment of the container:

- I go to the root of the project and I run the following command.

```bash
docker build -f ./config/production/Dockerfile -t learn/app/d9.3.8:1.0.1 --no-cache .
```

#### Command description

- We tell Docker which Dockerfile to use

```
-f ./config/production/Dockerfile 
```

- Then the name and the tags of the image

```
-t learn/app/d9.3.8:1.0.1
```

- We ask docker not to use caches

```
--no-cache
```

- We indicate the root location of the files to add in the images.

```
.
```
