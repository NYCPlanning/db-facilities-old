################################################################################################
## EXPORTING
################################################################################################
## NOTE: This script requires that your setup the DATABASE_URL environment variable. 
## Directions are in the README.md.

DBNAME=$(cat $REPOLOC/config.json | jq -r '.DBNAME')
DBUSER=$(cat $REPOLOC/config.json | jq -r '.DBUSER')

psql -U $DBUSER -d $DBNAME -f ./5_export/censor.sql
echo 'Exporting FacDB tables...'
psql -U $DBUSER -d $DBNAME -f ./5_export/export.sql
psql -U $DBUSER -d $DBNAME -f ./5_export/export_allbeforemerging.sql
psql -U $DBUSER -d $DBNAME -f ./5_export/export_unmapped.sql
psql -U $DBUSER -d $DBNAME -f ./5_export/export_datasources.sql
psql -U $DBUSER -d $DBNAME -f ./5_export/export_uid_key.sql
echo 'Exporting tables for mkdocs...'
psql -U $DBUSER -d $DBNAME -f ./5_export/mkdocs_datasources.sql
echo 'All done!'