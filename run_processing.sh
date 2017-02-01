################################################################################################
## PROCESSING
################################################################################################
## This file runs all the scripts which geocode and process all the assembled data
## NOTE: This script requires that your setup the DATABASE_URL environment variable. 
## Directions are in the README.md.

## Standardizing borough and assigning borough code
psql $DATABASE_URL -f ./scripts_processing/cleanup/standardize_borough.sql

## Switching One to 1 for geocoding and removing invalid (string) address numbers
psql $DATABASE_URL -f ./scripts_processing/cleanup/standardize_address.sql

## CREATING GEOMETRIES WITH GEOCLIENT

## Run the geocoding script using address and borough - get BBL, BIN, lat/long
echo 'Running geocoding script using address and borough...'
time node ./scripts_processing/geoclient/address2geom_borough.js
echo 'Done geocoding using address and borough'

## Run the geocoding script using address and zipcode - get BBL, BIN, lat/long
echo 'Running geocoding script using address and zip code...'
time node ./scripts_processing/geoclient/address2geom_zipcode.js
echo 'Done geocoding using address and zip code'

## FILLING IN STANDARDIZED ADDRESS AND LOCATION DETAILS WITH GEOCLIENT

# Do spatial join with borough for remaining records with geoms that have blanks
echo 'Forcing 2D...'
psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/force2D.sql
echo 'Forced 2D complete'
time psql $DATABASE_URL -f ./scripts_processing/joins/boroughjoin.sql
## ^ added this step because a lot of zipcode Geoclient searches weren't finding results

# Run the geocoding script using address get BBL and BIN and standardize address
echo 'Running geocoding script getting BBL using address and borough...'
time node ./scripts_processing/geoclient/address2bbl_borough.js
echo 'Done getting BBL using address and borough'

echo 'Running geocoding script getting BBL using address and zipcode...'
time node ./scripts_processing/geoclient/address2bbl_zipcode.js
echo 'Done getting BBL using address and zipcode'
# ^^ Hasn't been catching anything

## Standardizing borough and assigning borough code 
## (Geoclient sometimes fills in Staten Is instead of Staten Island)
psql $DATABASE_URL -f ./scripts_processing/cleanup/standardize_borough.sql

psql $DATABASE_URL -f ./scripts_processing/removeinvalidBIN.sql
psql $DATABASE_URL -f ./scripts_processing/backup/copy_backup1.sql

## CREATING GEOMS USING BIN AND BBL CENTROID FOR REMAINING MISSING GEOMS

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

## Create backup table of records with no geom or outside NYC and then delete from database

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

psql $DATABASE_URL -f ./scripts_processing/cleanup/standardize_address.sql
# ^ need to clean up addresses again after filling in with PLUTO address

echo 'Filling in missing BINS where there is a 1-1 relationship between BBL and BIN...'
time psql $DATABASE_URL -f ./scripts_processing/bbl2bin.sql

## TABULAR JOINS WITH BUILDINGFOOTPRINTS AND PLUTO TO OVERWRITE GEOMS

echo 'Creating a backup copy before overwriting any geometries...'
psql $DATABASE_URL -f ./scripts_processing/backup/copy_backup2.sql

echo 'Overwriting geometry using BIN centroid...'
time psql $DATABASE_URL -f ./scripts_processing/bin2overwritegeom.sql
echo 'Done overwriting geometry using BIN centroid'

echo 'Overwriting geometry using BBL centroid...'
time psql $DATABASE_URL -f ./scripts_processing/bbl2overwritegeom.sql
echo 'Done overwriting geometry using BBL centroid'

## Convert back to 4326, calculating lat,long and x,y for all blank records, and create ID for all records at once to use for deduping

psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/setSRID_4326.sql
echo 'Calculating x,y for all blank records...'
time psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/calcxy.sql
echo 'Done calculating x,y for all blank records'


echo 'Spatially joining with neighborhood boundaries...'
time psql $DATABASE_URL -f ./scripts_processing/joins/cdjoin.sql
time psql $DATABASE_URL -f ./scripts_processing/joins/ntajoin.sql
time psql $DATABASE_URL -f ./scripts_processing/joins/zipcodejoin.sql
time psql $DATABASE_URL -f ./scripts_processing/joins/counciljoin.sql
time psql $DATABASE_URL -f ./scripts_processing/joins/tractjoin.sql

# psql $DATABASE_URL -f ./scripts_processing/addID.sql

psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/vacuum.sql

# Create backup table before merging and dropping duplicates
echo 'Creating backup before merging and dropping duplicates...'
psql $DATABASE_URL -f ./scripts_processing/backup/copy_backup3.sql

## DEDUPING

## Merge Child Care and Pre-K Duplicate records
echo 'Merging and dropping Child Care and Pre-K duplicates...'
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_ccprek_acs_hhs.sql
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_ccprek_doe_acs.sql
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_ccprek_doe_dohmh.sql
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_ccprek_acs_dohmh.sql
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_ccprek_dohmh.sql

echo 'Merging and dropping remaining duplicates, pre-COLP...'
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_remaining.sql

echo 'Merging and dropping COLP duplicates by BIN and BBL...'
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_colp_bin.sql
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_colp_bbl.sql

psql $DATABASE_URL -f ./scripts_processing/backup/copy_backup4.sql

echo 'Finding and merging related COLP duplicates on surrounding BBLs...'

psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_colp_relatedlots_merged.sql
psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_colp_relatedlots_colponly.sql
echo 'Deduped!'

## Final export to csv that excludes null geoms and geoms outside NYC

echo 'Exporting...'
time psql $DATABASE_URL -f ./scripts_processing/export.sql
# sh ./scripts_processing/export_json.sh
echo 'All done!'



###########################################################################################
## NOT FINISHED AND/OR NOT WORKING BEYOND THIS POINT
###########################################################################################

## TO DO:

# # ## Run the geocoding script using place name (facilityname) - get BBL, BIN, lat/long
# # echo 'Running geocoding script using place name and borough...'
# # time node ./scripts_processing/place2geom_nameborough.js
# # echo 'Done geocoding using place name and borough'
# # # ^^ Hasn't been catching anything

# # ## Run the geocoding script using place name (address) - get BBL, BIN, lat/long
# # echo 'Running geocoding script using place name and zip code...'
# # time node ./scripts_processing/place2geom_addressborough.js
# # echo 'Done geocoding using place name and zip code'
# # ## ^^ Hasn't been catching anything


# # ## 5. Run the geocoding script using intersection - get BBL, BIN, lat/long
# node ./scripts_processing/intersection2geom.js
# # # ^^ Regex problems -- not working

# ## 6. Run BBLs through geoclient to get all formatted addresses and BINS for records without addresses
# node ./scripts_processing/bbl2address.js
# psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/vacuum.sql

# ## 11. Query for duplicate records (BBLs with more than one record on the same BBL) sourced
# ## from different datasets
# psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_samesource_copy.sql
# psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_samesource_delete.sql

# ## 12. Query for duplicate records (BBLs with more than one record on the same BBL) sourced
# ## from different datasets
# psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_diffsource_copy.sql
# psql $DATABASE_URL -f ./scripts_processing/duplicates/duplicates_diffsource_delete.sql

# ## 13. Remove records outside of NYC
# psql $DATABASE_URL -f ./scripts_processing/outsiders_copy.sql
# psql $DATABASE_URL -f ./scripts_processing/outsiders_delete.sql

# ## NIXED - For facilities which did not overlap with a BBL in MapPLUTO but should be located on a BBL lot, 
# ## assign the closest BBL to the record

# echo 'Spatially joining with dcp_mappluto - Finding closest...'
# time psql $DATABASE_URL -f ./scripts_processing/bbljoin_closest.sql
# echo 'Done spatially joining with dcp_mappluto - Found closest'
# psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/vacuum.sql

