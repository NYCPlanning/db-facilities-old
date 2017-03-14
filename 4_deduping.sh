################################################################################################
## DEDUPING
################################################################################################
## This file runs all the scripts which geocode and process all the assembled data
## NOTE: This script requires that your setup the DATABASE_URL environment variable. 
## Directions are in the README.md.

# ## DEDUPING

## Merge Child Care and Pre-K Duplicate records
echo 'Merging and dropping Child Care and Pre-K duplicates...'
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_ccprek_acs_hhs.sql
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_removeFAKE.sql
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_ccprek_doe_acs.sql
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_removeFAKE.sql
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_ccprek_doe_dohmh.sql
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_removeFAKE.sql
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_ccprek_acs_dohmh.sql
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_removeFAKE.sql
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_ccprek_dohmh.sql
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_removeFAKE.sql
psql $DATABASE_URL -f ./scripts_processing/backup/copy_backup4.sql

echo 'Merging and dropping remaining duplicates, pre-COLP...'
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_remaining.sql
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_removeFAKE.sql

echo 'Merging and dropping remaining duplicates, pre-COLP...'
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_sfpsd_relatedlots.sql
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_removeFAKE.sql

echo 'Creating backup before merging and dropping COLP duplicates...'
psql $DATABASE_URL -f ./scripts_processing/backup/copy_backup5.sql

echo 'Merging and dropping COLP duplicates by BIN...'
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_colp_bin_alt.sql
echo 'Cleaning up remaining dummy values used for array_agg'
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_removeFAKE.sql

echo 'Merging and dropping COLP duplicates by BBL...'
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_colp_bbl_alt.sql
echo 'Cleaning up remaining dummy values used for array_agg'
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_removeFAKE.sql

echo 'Merging related COLP duplicates on surrounding BBLs...'
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_colp_relatedlots_merged_alt.sql
echo 'Cleaning up remaining dummy values used for array_agg'
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_removeFAKE.sql

echo 'Merging remaining COLP duplicates on surrounding BBLs Part 1...'
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_colp_relatedlots_colponly_alt_p1.sql
echo 'Cleaning up remaining dummy values used for array_agg'
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_removeFAKE.sql

echo 'Merging remaining COLP duplicates on surrounding BBLs Part 2...'
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_colp_relatedlots_colponly_alt_p2.sql
echo 'Cleaning up remaining dummy values used for array_agg'
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_removeFAKE.sql

echo 'Deduped!'

echo 'Cleaning up duplicates in BIN and BBl arrays...'
psql $DATABASE_URL -f ./scripts_processing/cleanup/removeArrayDuplicates.sql

psql $DATABASE_URL -f ./scripts_processing/backup/copy_backup6.sql