################################################################################################
## GEOPROCESSING
################################################################################################
## This file runs all the scripts which geocode and process all the assembled data
## NOTE: This script requires that your setup the DATABASE_URL environment variable. 
## Directions are in the README.md.

## CREATING GEOMETRIES WITH GEOCLIENT

## Run the geocoding script using address and borough - get BBL, BIN, lat/long
echo 'Running geocoding script using address and borough...'
time node ./scripts_processing/geoclient/address2geom_borough.js
echo 'Done geocoding using address and borough'

## Run the geocoding script using address and zipcode - get BBL, BIN, lat/long
echo 'Running geocoding script using address and zip code...'
time node ./scripts_processing/geoclient/address2geom_zipcode.js
echo 'Done geocoding using address and zip code'

# ## FILLING IN STANDARDIZED ADDRESS AND LOCATION DETAILS WITH GEOCLIENT

# Do spatial join with borough for remaining records with geoms that have blanks
echo 'Forcing 2D...'
psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/force2D.sql
## !!! This shouldn't be run twice ^

echo 'Forced 2D complete'
psql $DATABASE_URL -f ./scripts_processing/joins/boroughjoin.sql
## ^ added this step because a lot of zipcode Geoclient searches weren't finding results

# Run the geocoding script using address get BBL and BIN and standardize address
echo 'Running geocoding script getting BBL using address and borough...'
time node ./scripts_processing/geoclient/address2bbl_borough.js
echo 'Done getting BBL using address and borough'

echo 'Running geocoding script getting BBL using address and zipcode...'
time node ./scripts_processing/geoclient/address2bbl_zipcode.js
echo 'Done getting BBL using address and zipcode'
# ^^ Hasn't been catching anything

## Standardizing borough and assigning borough code again because
## Geoclient sometimes fills in Staten Is instead of Staten Island
psql $DATABASE_URL -f ./scripts_processing/joins/boroughjoin.sql
psql $DATABASE_URL -f ./scripts_processing/cleanup/removeinvalidBIN.sql

psql $DATABASE_URL -f ./scripts_processing/backup/copy_backup1.sql

# # CREATING GEOMS USING BIN AND BBL CENTROID FOR REMAINING MISSING GEOMS

echo 'Filling in missing BINS where there is a 1-1 relationship between BBL and BIN...'
time psql $DATABASE_URL -f ./scripts_processing/bbl2bin.sql
## !!! This shouldn't be run twice ^

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
psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/setSRID_4326.sql
psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/vacuum.sql
echo 'Done indexing and vacuuming facilities and dcp_mappluto'

## Do a spatial join with MapPLUTO to get BBL and addresses info if missing

echo 'Spatially joining with dcp_mappluto...'
time psql $DATABASE_URL -f ./scripts_processing/bbljoin.sql
echo 'Done spatially joining with dcp_mappluto'
psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/vacuum.sql
psql $DATABASE_URL -f ./2_assembly/standardize_address.sql
# ^ need to clean up addresses again after filling in with PLUTO address

echo 'Filling in missing BINS where there is a 1-1 relationship between BBL and BIN...'
time psql $DATABASE_URL -f ./scripts_processing/bbl2bin.sql
# !!! This shouldn't be run twice ^

echo 'Creating a backup copy before overwriting any geometries...'
psql $DATABASE_URL -f ./scripts_processing/backup/copy_backup2.sql

# ## TABULAR JOINS WITH BUILDINGFOOTPRINTS AND PLUTO TO OVERWRITE GEOMS

echo 'Overwriting geometry using BIN centroid...'
time psql $DATABASE_URL -f ./scripts_processing/bin2overwritegeom.sql
echo 'Done overwriting geometry using BIN centroid'

echo 'Overwriting geometry using BBL centroid...'
time psql $DATABASE_URL -f ./scripts_processing/bbl2overwritegeom.sql
echo 'Done overwriting geometry using BBL centroid'

## Convert back to 4326, calculating lat,long and x,y for all blank records
echo 'Calculating x,y for all blank records...'
time psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/calcxy.sql
echo 'Done calculating x,y for all blank records'

echo 'Spatially joining with neighborhood boundaries...'
time psql $DATABASE_URL -f ./scripts_processing/joins/cdjoin.sql
time psql $DATABASE_URL -f ./scripts_processing/joins/ntajoin.sql
time psql $DATABASE_URL -f ./scripts_processing/joins/zipcodejoin.sql
psql $DATABASE_URL -f ./scripts_processing/cleanup/removeinvalidZIP.sql
time psql $DATABASE_URL -f ./scripts_processing/joins/counciljoin.sql
time psql $DATABASE_URL -f ./scripts_processing/joins/tractjoin.sql
time psql $DATABASE_URL -f ./scripts_processing/joins/boroughjoin.sql
psql $DATABASE_URL -f ./scripts_processing/cleanup/cleanup_cityboro.sql
psql $DATABASE_URL -f ./2_assembly/standardize_borough.sql
# echo 'Spatially joining with COLP bbls to get propertytype...'
time psql $DATABASE_URL -f ./scripts_processing/joins/propertytypejoin.sql
echo 'Setting propertytype for street plazas...'
psql $DATABASE_URL -f ./scripts_processing/cleanup/plazas.sql
psql $DATABASE_URL -f ./scripts_processing/cleanup_spatial/vacuum.sql

# Create backup table before merging and dropping duplicates
echo 'Creating backup before merging and dropping duplicates...'
psql $DATABASE_URL -f ./scripts_processing/backup/copy_backup3.sql