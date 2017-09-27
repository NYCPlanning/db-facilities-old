#################################################################################################
## GEOPROCESSING
#################################################################################################
## NOTE: This script requires that your setup the DATABASE_URL environment variable. 
## Directions are in the README.md.

DBNAME=$(cat config.json | jq -r '.DBNAME')
DBUSER=$(cat config.json | jq -r '.DBUSER')

## PREPPING DATA

echo 'Creating a backup copy before doing any geoprocessing...'
# time psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/copy_backup0.sql
echo 'Forcing 2D...'
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/force2D.sql
echo 'Setting SRID, indexing, and vacuuming facilities and dcp_mappluto...'
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/setSRID_4326.sql
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/vacuum.sql
echo 'Spatial join with boroughs...'
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/join_boro_pregeoclient.sql
## This joins borough onto records that do not have borough or zip code already assigned. This distinction is important because some records came with coordinates that were the result of incorrect geocoding. There are records that have addresses that exist in multiple boroughs, and there are cases where a record comes with boro=Manhattan but it's coordinates are at the location at the same address that's in Brooklyn instead. We want to be careful to not override the borough values that were provided and should be skeptical of coordinates provided on the open data portal that were likely generated automatically without any QA/QC. We only want to fill in borough for the cases where no other borough or zipcode value was provided so we enable potential for finding matches in GeoClient what wouldn't be possible otherwise.

## GEOCLIENT

## Run all records with addresses through GeoClient to get BBL, BIN, and lat/long if missing
echo 'Running through GeoClient using address and borough...'
node ./3_geoprocessing/geoclient_boro.js
echo 'Running through GeoClient using address and zip code...'
node ./3_geoprocessing/geoclient_zipcode.js
## Standardizing borough and assigning borough code again because
## Geoclient sometimes fills in Staten Is instead of Staten Island
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/join_boro.sql
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/clean_invalidBIN.sql
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/copy_backup1.sql

## TABULAR JOIN WITH PLUTO FILLING IN MISSING ADDRESS INFO USING BBL WHEN GEOM EXISTS

echo 'Joining missing address info onto records using BBL...'
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/join_PLUTOtabular.sql

## SPATIAL JOINS WITH PLUTO TO GET BBL AND OTHER MISSING INFO

echo 'Spatially joining with dcp_mappluto...'
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/join_PLUTOspatial.sql
echo 'Done spatially joining with dcp_mappluto'
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/vacuum.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize/standardize_address.sql
# ^ need to clean up addresses again after filling in with PLUTO address

## FILLING IN REMAINING MISSING BINS

echo 'Filling in missing BINS where there is a 1-1 relationship between BBL and BIN...'
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/bbl2bin.sql
echo 'Creating a backup copy before overwriting any geometries...'
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/copy_backup2.sql

# TABULAR JOINS WITH BUILDINGFOOTPRINTS AND PLUTO TO OVERWRITE GEOMS WITH CENTROID

echo 'Overwriting geometry using BIN centroid...'
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/bin2overwritegeom.sql
echo 'Done overwriting geometry using BIN centroid'

echo 'Overwriting geometry using BBL centroid...'
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/bbl2overwritegeom.sql
echo 'Done overwriting geometry using BBL centroid'

## Calculating lat,long and x,y for all blank records
echo 'Calculating x,y for all blank records...'
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/calcxy.sql
echo 'Done calculating x,y for all blank records'

echo 'Spatially joining with neighborhood boundaries...'
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/join_commboard.sql
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/join_nta.sql
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/join_zipcode.sql
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/join_council.sql
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/join_censtract.sql
## Cleaning up values
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/clean_invalidZIP.sql
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/clean_cityboro.sql
echo 'Spatially joining with COLP bbls to get propertytype...'
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/join_proptype.sql
## ^ In FacDB V1.5, will add conditional logic for type of facility
echo 'Setting propertytype for street plazas...'
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/proptype_plazas.sql
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/vacuum.sql

## Create backup table before merging and dropping duplicates
echo 'Creating backup before merging and dropping duplicates...'
psql -U $DBUSER -d $DBNAME -f ./3_geoprocessing/copy_backup3.sql