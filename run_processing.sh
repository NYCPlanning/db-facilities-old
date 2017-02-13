################################################################################################
## PROCESSING
################################################################################################
## This file runs all the scripts which geocode and process all the assembled data
## NOTE: This script requires that your setup the DATABASE_URL environment variable. 
## Directions are in the README.md.

# ## CREATING GEOMETRIES WITH GEOCLIENT

# ## Run the geocoding script using address and borough - get BBL, BIN, lat/long
# echo 'Running geocoding script using address and borough...'
# time node ./scripts_processing/geoclient/address2geom_borough.js
# echo 'Done geocoding using address and borough'

# ## Run the geocoding script using address and zipcode - get BBL, BIN, lat/long
# echo 'Running geocoding script using address and zip code...'
# time node ./scripts_processing/geoclient/address2geom_zipcode.js
# echo 'Done geocoding using address and zip code'

# ## FILLING IN STANDARDIZED ADDRESS AND LOCATION DETAILS WITH GEOCLIENT

# # Do spatial join with borough for remaining records with geoms that have blanks
# echo 'Forcing 2D...'
# psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/force2D.sql
# echo 'Forced 2D complete'
# psql $DATABASE_URL -f ./scripts_processing/joins/boroughjoin.sql
# ## ^ added this step because a lot of zipcode Geoclient searches weren't finding results

# # Run the geocoding script using address get BBL and BIN and standardize address
# echo 'Running geocoding script getting BBL using address and borough...'
# time node ./scripts_processing/geoclient/address2bbl_borough.js
# echo 'Done getting BBL using address and borough'

# echo 'Running geocoding script getting BBL using address and zipcode...'
# time node ./scripts_processing/geoclient/address2bbl_zipcode.js
# echo 'Done getting BBL using address and zipcode'
# # ^^ Hasn't been catching anything

# ## Standardizing borough and assigning borough code again because
# ## Geoclient sometimes fills in Staten Is instead of Staten Island
psql $DATABASE_URL -f ./scripts_processing/joins/boroughjoin.sql
psql $DATABASE_URL -f ./scripts_processing/cleanup/removeinvalidBIN.sql

psql $DATABASE_URL -f ./scripts_processing/backup/copy_backup1.sql

## CREATING GEOMS USING BIN AND BBL CENTROID FOR REMAINING MISSING GEOMS

echo 'Filling in missing BINS where there is a 1-1 relationship between BBL and BIN...'
time psql $DATABASE_URL -f ./scripts_processing/bbl2bin.sql

echo 'Joining on geometry using BIN...'
time psql $DATABASE_URL -f ./scripts_processing/bin2geom.sql
echo 'Done joining on geometry using BIN'

echo 'Joining on geometry using BBL...'
time psql $DATABASE_URL -f ./scripts_processing/bbl2geom.sql
echo 'Done joining on geometry using BBL'
# ^^ Hasn't been catching anything

## FILLING IN MISSING ADDRESS INFO FROM PLUTO USING BBL WHEN GEOM EXISTS

echo 'Joining missing address info using BBL...'
time psql $DATABASE_URL -f ./scripts_processing/bbl2address.sql

## PREPPING FOR SPATIAL JOINS WITH PLUTO

## Create a spatial index for the facilities database and for MapPLUTO and VACUUM
## (Reindex and vacuum after each spatial join)

echo 'Indexing and vacuuming facilities and dcp_mappluto...'
psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/force2D.sql
psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/setSRID_26918.sql
psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/vacuum.sql
echo 'Done indexing and vacuuming facilities and dcp_mappluto'

## Do a spatial join with MapPLUTO to get BBL and addresses info if missing

echo 'Spatially joining with dcp_mappluto...'
time psql $DATABASE_URL -f ./scripts_processing/bbljoin.sql
echo 'Done spatially joining with dcp_mappluto'
psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/vacuum.sql
psql $DATABASE_URL -f ./scripts_assembly/standardize_address.sql
# ^ need to clean up addresses again after filling in with PLUTO address

echo 'Filling in missing BINS where there is a 1-1 relationship between BBL and BIN...'
time psql $DATABASE_URL -f ./scripts_processing/bbl2bin.sql

echo 'Creating a backup copy before overwriting any geometries...'
psql $DATABASE_URL -f ./scripts_processing/backup/copy_backup2.sql

## TABULAR JOINS WITH BUILDINGFOOTPRINTS AND PLUTO TO OVERWRITE GEOMS

## Creating uid integer value for blanks
psql $DATABASE_URL -f ./scripts_processing/addID.sql

## Convert back to 4326, calculating lat,long and x,y for all blank records
psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/setSRID_4326.sql
echo 'Calculating x,y for all blank records...'
time psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/calcxy.sql
echo 'Done calculating x,y for all blank records'

echo 'Overwriting geometry using BIN centroid...'
time psql $DATABASE_URL -f ./scripts_processing/bin2overwritegeom.sql
echo 'Done overwriting geometry using BIN centroid'

echo 'Overwriting geometry using BBL centroid...'
time psql $DATABASE_URL -f ./scripts_processing/bbl2overwritegeom.sql
echo 'Done overwriting geometry using BBL centroid'

echo 'Spatially joining with neighborhood boundaries...'
time psql $DATABASE_URL -f ./scripts_processing/joins/cdjoin.sql
time psql $DATABASE_URL -f ./scripts_processing/joins/ntajoin.sql
time psql $DATABASE_URL -f ./scripts_processing/joins/zipcodejoin.sql
psql $DATABASE_URL -f ./scripts_processing/cleanup/removeinvalidZIP.sql
time psql $DATABASE_URL -f ./scripts_processing/joins/counciljoin.sql
time psql $DATABASE_URL -f ./scripts_processing/joins/tractjoin.sql
time psql $DATABASE_URL -f ./scripts_processing/joins/boroughjoin.sql
psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/vacuum.sql

# Create backup table before merging and dropping duplicates
echo 'Creating backup before merging and dropping duplicates...'
psql $DATABASE_URL -f ./scripts_processing/backup/copy_backup3.sql

## DEDUPING

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

echo 'Merging and dropping remaining duplicates, pre-COLP...'
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_remaining.sql
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_removeFAKE.sql

echo 'Creating backup before merging and dropping COLP duplicates...'
psql $DATABASE_URL -f ./scripts_processing/backup/copy_backup4.sql

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
echo 'Setting propertytype for street plazas...'
psql $DATABASE_URL -f ./scripts_processing/cleanup/plazas.sql


## Final export to csv that excludes null geoms and geoms outside NYC

echo 'Exporting...'
time psql $DATABASE_URL -f ./scripts_processing/export.sql
echo 'All done!'
