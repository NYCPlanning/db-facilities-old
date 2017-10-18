################################################################################################
## DEDUPING
################################################################################################
## NOTE: This script requires that your setup the DATABASE_URL environment variable. 
## Directions are in the README.md.

DBNAME=$(cat $REPOLOC/config.json | jq -r '.DBNAME')
DBUSER=$(cat $REPOLOC/config.json | jq -r '.DBUSER')

## DEDUPING

## Make a backup
psql -U $DBUSER -d $DBNAME -f ./4_deduping/copy_backuppredup.sql

# Create relatipnal tables
psql -U $DBUSER -d $DBNAME -f ./2_assembly/create/agencyid.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/create/area.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/create/bbl.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/create/bin.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/create/capacity.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/create/hashesmerged.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/create/oversight.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/create/pgtable.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/create/uid.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/create/uidsmerged.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/create/utilization.sql

## Reconciling duplicate records 
psql -U $DBUSER -d $DBNAME -f ./4_deduping/exactsame.sql


# # Merge Child Care and Pre-K Duplicate records
# echo 'Merging and dropping Child Care and Pre-K duplicates...'
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_ccprek_acs_hhs.sql
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_ccprek_doe_acs.sql
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_ccprek_doe_dohmh.sql
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_ccprek_acs_dohmh.sql
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_ccprek_dohmh.sql
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/copy_backup4.sql

# echo 'Merging and dropping remaining duplicates, pre-COLP...'
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_remaining.sql
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql

# echo 'Merging and dropping remaining duplicates, pre-COLP...'
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_sfpsd_relatedlots.sql
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql

# echo 'Creating backup before merging and dropping COLP duplicates...'
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/copy_backup5.sql

# echo 'Merging and dropping COLP duplicates by BIN...'
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_colp_bin.sql
# echo 'Cleaning up remaining dummy values used for array_agg'
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql

# echo 'Merging and dropping COLP duplicates by BBL...'
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_colp_bbl.sql
# echo 'Cleaning up remaining dummy values used for array_agg'
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql

# echo 'Merging related COLP duplicates on surrounding BBLs...'
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_colp_relatedlots_merged.sql
# echo 'Cleaning up remaining dummy values used for array_agg'
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql

# echo 'Merging remaining COLP duplicates on surrounding BBLs Part 1...'
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_colp_relatedlots_colponly_p1.sql
# echo 'Cleaning up remaining dummy values used for array_agg'
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql

# echo 'Merging remaining COLP duplicates on surrounding BBLs Part 2...'
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_colp_relatedlots_colponly_p2.sql
# echo 'Cleaning up remaining dummy values used for array_agg'
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql

# # Merge records that are exactly the same from the same data source
# echo 'Merging and dropping records that are exactly the same from the same data source...'
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_exactsame.sql
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/duplicates_removeFAKE.sql

# echo 'Deduped!'

# echo 'Cleaning up duplicates in BIN and BBl arrays...'
# psql -U $DBUSER -d $DBNAME -f ./4_deduping/removeArrayDuplicates.sql

# psql -U $DBUSER -d $DBNAME -f ./4_deduping/copy_backup6.sql