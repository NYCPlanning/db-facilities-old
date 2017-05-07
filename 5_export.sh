################################################################################################
## EXPORTING
################################################################################################
## NOTE: This script requires that your setup the DATABASE_URL environment variable. 
## Directions are in the README.md.

time psql $DATABASE_URL -f ./5_export/censor.sql
echo 'Exporting FacDB tables...'
time psql $DATABASE_URL -f ./5_export/export.sql
time psql $DATABASE_URL -f ./5_export/export_allbeforemerging.sql
time psql $DATABASE_URL -f ./5_export/export_unmapped.sql
time psql $DATABASE_URL -f ./5_export/export_datasources.sql
time psql $DATABASE_URL -f ./5_export/export_uid_key.sql
echo 'Exporting tables for mkdocs...'
time psql $DATABASE_URL -f ./5_export/tables_mkdocs/mkdocs_datasources.sql
echo 'All done!'