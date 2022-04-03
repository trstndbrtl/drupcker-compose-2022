#!/bin/bash
#
# We exit if there is a problem while executing this script
set -ex
# Show message debug
echo 'Start of processes at container startup'
# During drush operations, access to the db must be OP,
# if an error occurs at this step, the container does not start.
# Let's check that there is no update operation pending in db
drush updb
# We clean the caches
drush cr
# We import the configurations
drush cim -y
# We clean the caches
drush cr
# Then, if the import of the configurations requires a modification of the schema of the db, a last drush updb
drush updb
# https://stackoverflow.com/questions/39082768/what-does-set-e-and-exec-do-for-docker-entrypoint-scripts
exec "$@"
#
#
# On sort s'il y a un problème lors de l'execution de ce script
# set -ex
# On affiche un message de debug
# echo 'Start of processes at container startup'
# # Lors des opérations drush, l'accès à la db doit etre OP,
# # si une erreur survint à cette étape, le container ne demarre pas.
# # Verifions qu'il n'y a pas d'opération de màj en attente en db
# drush updb
# # On nettoie les caches
# drush cr
# # On importe les configurations
# drush cim -y
# # On nettoie les caches
# drush cr
# # Puis, si l'import des configurations necessite une modification du shema de la db, un dernier drush updb
# drush updb
# https://stackoverflow.com/questions/39082768/what-does-set-e-and-exec-do-for-docker-entrypoint-scripts
# exec "$@"
#
#