################################################################################################
## DEDUPING
################################################################################################
## NOTE: This script requires that your setup the DATABASE_URL environment variable. 
## Directions are in the README.md.

DBNAME=$(cat $REPOLOC/config.json | jq -r '.DBNAME')
DBUSER=$(cat $REPOLOC/config.json | jq -r '.DBUSER')

## DEDUPING

# Merge Child Care and Pre-K Duplicate records
echo 'Merging and dropping Child Care and Pre-K duplicates...'
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_ccprek_acs_hhs.sql
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_ccprek_doe_acs.sql
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_ccprek_doe_dohmh.sql
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_ccprek_acs_dohmh.sql
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_ccprek_dohmh.sql
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/copy_backup4.sql

echo 'Merging and dropping remaining duplicates, pre-COLP...'
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_remaining.sql
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql

echo 'Merging and dropping remaining duplicates, pre-COLP...'
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_sfpsd_relatedlots.sql
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql

echo 'Creating backup before merging and dropping COLP duplicates...'
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/copy_backup5.sql

echo 'Merging and dropping COLP duplicates by BIN...'
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_colp_bin.sql
echo 'Cleaning up remaining dummy values used for array_agg'
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql

echo 'Merging and dropping COLP duplicates by BBL...'
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_colp_bbl.sql
echo 'Cleaning up remaining dummy values used for array_agg'
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql

echo 'Merging related COLP duplicates on surrounding BBLs...'
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_colp_relatedlots_merged.sql
echo 'Cleaning up remaining dummy values used for array_agg'
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql

echo 'Merging remaining COLP duplicates on surrounding BBLs Part 1...'
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_colp_relatedlots_colponly_p1.sql
echo 'Cleaning up remaining dummy values used for array_agg'
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql

echo 'Merging remaining COLP duplicates on surrounding BBLs Part 2...'
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_colp_relatedlots_colponly_p2.sql
echo 'Cleaning up remaining dummy values used for array_agg'
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql

# Merge records that are exactly the same from the same data source
echo 'Merging and dropping records that are exactly the same from the same data source...'
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_exactsame.sql
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql

echo 'Deduped!'

echo 'Cleaning up duplicates in BIN and BBl arrays...'
time psql -U $DBUSER -d $DBNAME -f ./4_deduping/removeArrayDuplicates.sql

time psql -U $DBUSER -d $DBNAME -f ./4_deduping/copy_backup6.sql