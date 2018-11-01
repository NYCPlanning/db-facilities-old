################################################################################################
## RUNNING QA QC JOBS
################################################################################################
## NOTE: This script requires that your setup the DATABASE_URL environment variable. 
## Directions are in the README.md.

DBNAME=$(cat config.json | jq -r '.DBNAME')
DBUSER=$(cat config.json | jq -r '.DBUSER')

echo 'Running qa qc jobs'
psql -U $DBUSER -d $DBNAME -f ./6_qaqc/qc_frequencychangefactype.sql
psql -U $DBUSER -d $DBNAME -f ./6_qaqc/qc_frequencychangeoversight.sql
psql -U $DBUSER -d $DBNAME -f ./6_qaqc/qc_frequencychangesource.sql
psql -U $DBUSER -d $DBNAME -f ./6_qaqc/qc_frequencychangesubgroup.sql
psql -U $DBUSER -d $DBNAME -f ./6_qaqc/qc_frequencygeocomparison.sql
psql -U $DBUSER -d $DBNAME -f ./6_qaqc/qc_geocodingreport.sql