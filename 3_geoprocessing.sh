################################################################################################
## GEOPROCESSING
################################################################################################
## NOTE: This script requires that your setup the DATABASE_URL environment variable. 
## Directions are in the README.md.


## PREPPING DATA

echo 'Creating a backup copy before doing any geoprocessing...'
time psql $DATABASE_URL -f ./3_geoprocessing/copy_backup0.sql
echo 'Forcing 2D...'
time psql $DATABASE_URL -f ./3_geoprocessing/force2D.sql
echo 'Setting SRID, indexing, and vacuuming facilities and dcp_mappluto...'
time psql $DATABASE_URL -f ./3_geoprocessing/setSRID_4326.sql
time psql $DATABASE_URL -f ./3_geoprocessing/vacuum.sql
echo 'Spatial join with boroughs...'
time psql $DATABASE_URL -f ./3_geoprocessing/join_boro.sql

## GEOCLIENT

## Run all records with addresses through GeoClient to get BBL, BIN, and lat/long if missing
echo 'Running through GeoClient using address and borough...'
time node ./3_geoprocessing/geoclient/geoclient_boro.js
echo 'Running through GeoClient using address and zip code...'
time node ./3_geoprocessing/geoclient/geoclient_zipcode.js
## Standardizing borough and assigning borough code again because
## Geoclient sometimes fills in Staten Is instead of Staten Island
time psql $DATABASE_URL -f ./3_geoprocessing/join_boro.sql
time psql $DATABASE_URL -f ./3_geoprocessing/clean_invalidBIN.sql
time psql $DATABASE_URL -f ./3_geoprocessing/copy_backup1.sql

## TABULAR JOIN WITH PLUTO FILLING IN MISSING ADDRESS INFO USING BBL WHEN GEOM EXISTS

echo 'Joining missing address info onto records using BBL...'
time psql $DATABASE_URL -f ./3_geoprocessing/join_PLUTOtabular.sql

## SPATIAL JOINS WITH PLUTO TO GET BBL AND OTHER MISSING INFO

echo 'Spatially joining with dcp_mappluto...'
time psql $DATABASE_URL -f ./3_geoprocessing/join_PLUTOspatial.sql
echo 'Done spatially joining with dcp_mappluto'
time psql $DATABASE_URL -f ./3_geoprocessing/vacuum.sql
time psql $DATABASE_URL -f ./2_assembly/standardize_address.sql
# ^ need to clean up addresses again after filling in with PLUTO address

## FILLING IN REMAINING MISSING BINS

echo 'Filling in missing BINS where there is a 1-1 relationship between BBL and BIN...'
time psql $DATABASE_URL -f ./3_geoprocessing/bbl2bin.sql
echo 'Creating a backup copy before overwriting any geometries...'
time psql $DATABASE_URL -f ./3_geoprocessing/copy_backup2.sql

# TABULAR JOINS WITH BUILDINGFOOTPRINTS AND PLUTO TO OVERWRITE GEOMS WITH CENTROID

echo 'Overwriting geometry using BIN centroid...'
time psql $DATABASE_URL -f ./3_geoprocessing/bin2overwritegeom.sql
echo 'Done overwriting geometry using BIN centroid'

echo 'Overwriting geometry using BBL centroid...'
time psql $DATABASE_URL -f ./3_geoprocessing/bbl2overwritegeom.sql
echo 'Done overwriting geometry using BBL centroid'

## Calculating lat,long and x,y for all blank records
echo 'Calculating x,y for all blank records...'
time psql $DATABASE_URL -f ./3_geoprocessing/calcxy.sql
echo 'Done calculating x,y for all blank records'

echo 'Spatially joining with neighborhood boundaries...'
time psql $DATABASE_URL -f ./3_geoprocessing/join_commboard.sql
time psql $DATABASE_URL -f ./3_geoprocessing/join_nta.sql
time psql $DATABASE_URL -f ./3_geoprocessing/join_zipcode.sql
time psql $DATABASE_URL -f ./3_geoprocessing/clean_invalidZIP.sql
time psql $DATABASE_URL -f ./3_geoprocessing/clean_cityboro.sql
time psql $DATABASE_URL -f ./3_geoprocessing/join_council.sql
time psql $DATABASE_URL -f ./3_geoprocessing/join_censtract.sql
echo 'Spatially joining with COLP bbls to get propertytype...'
time psql $DATABASE_URL -f ./3_geoprocessing/join_proptype.sql
## ^ In FacDB V1.5, will add conditional logic for type of facility
echo 'Setting propertytype for street plazas...'
time psql $DATABASE_URL -f ./3_geoprocessing/proptype_plazas.sql
time psql $DATABASE_URL -f ./3_geoprocessing/vacuum.sql

## Create backup table before merging and dropping duplicates
echo 'Creating backup before merging and dropping duplicates...'
time psql $DATABASE_URL -f ./3_geoprocessing/copy_backup3.sql