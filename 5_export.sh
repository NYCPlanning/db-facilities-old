################################################################################################
## EXPORTING
################################################################################################
## NOTE: This script requires that your setup the DATABASE_URL environment variable. 
## Directions are in the README.md.

echo 'Exporting...'
time psql $DATABASE_URL -f ./5_export/export.sql
time psql $DATABASE_URL -f ./5_export/export_allbeforemerging.sql
time psql $DATABASE_URL -f ./5_export/export_unmapped.sql
time psql $DATABASE_URL -f ./5_export/export_datasources.sql
time psql $DATABASE_URL -f ./5_export/docs_datasources.sql
echo 'All done!'