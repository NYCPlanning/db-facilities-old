################################################################################################
## EXPORTING
################################################################################################
## NOTE: This script requires that your setup the DATABASE_URL environment variable. 
## Directions are in the README.md.

DBNAME=$(cat config.json | jq -r '.DBNAME')
DBUSER=$(cat config.json | jq -r '.DBUSER')

time psql -U $DBUSER -d $DBNAME -f ./5_export/censor.sql
echo 'Exporting FacDB tables...'
time psql -U $DBUSER -d $DBNAME -f ./5_export/export.sql
time psql -U $DBUSER -d $DBNAME -f ./5_export/export_allbeforemerging.sql
time psql -U $DBUSER -d $DBNAME -f ./5_export/export_unmapped.sql
time psql -U $DBUSER -d $DBNAME -f ./5_export/export_datasources.sql
time psql -U $DBUSER -d $DBNAME -f ./5_export/export_uid_key.sql
echo 'Exporting tables for mkdocs...'
time psql -U $DBUSER -d $DBNAME -f ./5_export/mkdocs_datasources.sql
echo 'All done!'